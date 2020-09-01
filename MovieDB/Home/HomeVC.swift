//
//  HomeVC.swift
//  MovieDB
//
//  Created by Apple on 8/18/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit
import Alamofire

class HomeVC: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    var refreshControl = UIRefreshControl()
    let defaults = UserDefaults.standard
    var deviceWidth:CGFloat!
    var deviceHeight:CGFloat!
    let spacing:CGFloat = 10
    let col = 2
    var movieData: [Movie]?
    var page: Int = 1
    var isLoadMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestToken()
        getListMovie(){()in}
        setupUI()
    }
    
    func setupUI() {
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        deviceWidth = view.bounds.width
        deviceHeight = view.bounds.height
        
        movieCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        refreshControl.attributedTitle = NSAttributedString(string: "loading")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        movieCollectionView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        self.movieData = nil
        self.page = 1
        getListMovie(){() in
            self.refreshControl.endRefreshing()
        }
    }
    
    func getListMovie( completion:@escaping () -> Void ) {
        AuthService.shared.requestListMovie(){ (result) in
            switch result {
            case .success(let data):
                self.movieData = data?.results
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                    completion()
                }
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
    
    func requestToken() {
        AuthService.shared.getToken(){ (result) in
            switch result {
            case .success(let success):
                guard let requestTokenString = success?.requestToken else { return }
                self.defaults.set(requestTokenString, forKey: defaultsKey.token)
                self.createRequestTokenString(token: requestTokenString)
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
    
    func createRequestTokenString(token: String) {
        guard let userName = self.defaults.string(forKey: defaultsKey.iD) else { return }
        guard let passWord = self.defaults.string(forKey: defaultsKey.password) else { return }
        AuthService.shared.getTokenByLogin(userName: userName, passWord: passWord, token: token){ (result) in
            switch result {
            case .success(let data):
                guard let tokenLoginRequest = data?.requestToken else { return }
                self.defaults.set(tokenLoginRequest, forKey: defaultsKey.token)
                self.createSessionID(token: tokenLoginRequest)
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
    
    func createSessionID(token: String) {
        AuthService.shared.requestCreateSession(token: token){ (result) in
            switch result {
            case .success(let data):
                guard let sessionID = data?.sessionId else { return }
                print("=))))))) \(sessionID)")
                self.defaults.set(sessionID, forKey: defaultsKey.sessionID)
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
    
    func getListMovieWithPage(page: Int) {
        AuthService.shared.requestListMovieWithPage(page: page){ (result) in
            switch result {
            case .success(let data):
                self.isLoadMore = true
                self.movieData! += (data?.results)!
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        guard let data = self.movieData else { return cell }
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
        return CGSize(width: width, height: deviceHeight/2.5)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 0 && self.movieData != nil {
            if isLoadMore {
                isLoadMore = false
                self.page += 1
                self.getListMovieWithPage(page: self.page)
            }
        }
    }
}

extension HomeVC: MovieCellProtocol {
    func callDeleteItem(movieID: Int) {}
    
    func callAddItem(movieID: Int) {
        let listVC = ListVC(nibName: "ListVC", bundle: nil)
        listVC.isAdd = true
        listVC.delegate = self
        listVC.movieID = movieID
        let navController = UINavigationController(rootViewController: listVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    func passIdMovie(id: Int) {
        let movieDetailVC = MovieDetailVC(nibName: "MovieDetailVC", bundle: nil)
        self.navigationController?.pushViewController(movieDetailVC, animated: false)
        movieDetailVC.MovieId = id
    }
}

extension HomeVC: ListVCDelegate {
    func passData(listID: Int, movieID: Int) {
        guard let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) else { return }
        self.dismiss(animated: true){()in
            AuthService.shared.addMovie(listID: listID, sessionID: sessionID, movieID: movieID){ (result) in
                switch result {
                case .success(let data):
                    guard let message = data!.statusMessage else { return }
                    Alert.instance.oneOption(this: self, title: "SUCCESS", content: message , titleButton: "OK") {() in }
                case .failure(let error):
                    guard let status = error.statusCode else { return }
                    guard let message = error.statusMessage else { return }
                    if status == 8 {
                        Alert.instance.oneOption(this: self, title: "NOTIFICATION", content: message , titleButton: "OK") {() in }
                    } else {
                        Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                    }
                }
            }
        }
    }
}
