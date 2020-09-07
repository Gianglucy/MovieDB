//
//  DetailListVC.swift
//  MovieDB
//
//  Created by Apple on 8/31/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

protocol DetailListVCDelegate {
    func callBack()
}

class DetailListVC: UIViewController {
    
    @IBOutlet weak var listMovieCollectionView: UICollectionView!
    var titleScreen: String?
    var listID: Int?
    var movie: [Movie]?
    var deviceWidth:CGFloat!
    var deviceHeight:CGFloat!
    let spacing:CGFloat = 10
    let col = 2
    let defaults = UserDefaults.standard
    var index: Int = 0
    var delegate: DetailListVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let listID = listID else { return }
        getDetailList(listID: listID)
        setupUI()
    }
    
    func setupUI() {
        self.title = titleScreen
        
        listMovieCollectionView.delegate = self
        listMovieCollectionView.dataSource = self
        
        deviceWidth = view.bounds.width
        deviceHeight = view.bounds.height
        
        listMovieCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
    }
    
    func getDetailList(listID: Int) {
        AuthService.shared.getDetailList(listID: listID){(result) in
            switch result {
            case .success(let data):
                self.movie = data?.items
                DispatchQueue.main.async {
                    self.listMovieCollectionView.reloadData()
                }
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
}

extension DetailListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = listMovieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        guard let data = self.movie else { return cell }
        cell.addListButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        cell.addListButton.tintColor = .systemRed
        cell.configCell(movie: data[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - (CGFloat(col + 1) * CGFloat(spacing))) / 2
        return CGSize(width: width, height: deviceHeight/2)
    }
}

extension DetailListVC: MovieCellProtocol {
    func voteMovie(movie: Movie) {}
    
    func passIdMovie(id: Int) {
        let movieDetailVC = MovieDetailVC(nibName: "MovieDetailVC", bundle: nil)
        self.navigationController?.pushViewController(movieDetailVC, animated: false)
        movieDetailVC.MovieId = id
    }
    
    func callAddItem(movieID: Int) {}
    
    func callDeleteItem(movieID: Int) {
        guard let listID = listID else { return }
        guard let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) else { return }
        AuthService.shared.deleteMovie(listID: listID, sessionID: sessionID, movieID: movieID){ (result) in
            switch result {
            case .success(let data):
                guard let message = data!.statusMessage else { return }
                self.getDetailList(listID: listID)
                Alert.instance.oneOption(this: self, title: "SUCCESS", content: message , titleButton: "OK") {() in
                    self.delegate?.callBack()
                }
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
}
