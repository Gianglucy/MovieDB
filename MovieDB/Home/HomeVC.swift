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
    var page: Int = 1
    var isLoadMore = true
    var homeViewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVM()
        requestToken()
        homeViewModel?.getListMovie(){()in}
        setupUI()
    }
    
    func setupVM() {
        homeViewModel = HomeViewModel()
        homeViewModel?.delegate = self
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
        homeViewModel?.movieData = nil
        self.page = 1
        homeViewModel?.getListMovie(){() in
            self.refreshControl.endRefreshing()
        }
    }
    
    func requestToken() {
        homeViewModel?.requestToken()
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel?.movieData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        guard let data = homeViewModel?.movieData else { return cell }
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
        if scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.height < 0 && homeViewModel?.movieData != nil {
            if isLoadMore {
                isLoadMore = false
                self.page += 1
                homeViewModel?.getListMovieWithPage(page: self.page)
            }
        }
    }
}

extension HomeVC: MovieCellProtocol {
    func voteMovie(movie: Movie) {
        let rateVC = RateVC(nibName: "RateVC", bundle: nil)
        rateVC.movie = movie
        let navController = UINavigationController(rootViewController: rateVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .flipHorizontal
        self.present(navController, animated: true, completion: nil)
    }
    
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
            self.homeViewModel?.addMovie(listID: listID, sessionID: sessionID, movieID: movieID)
        }
    }
}

extension HomeVC: HomeViewModelDelegate {
    func addMovieSuccess(data: ResponseError) {
        guard let message = data.statusMessage else { return }
        Alert.instance.oneOption(this: self, title: "SUCCESS", content: message , titleButton: "OK") {() in }
    }
    
    func successGetListMovie() {
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
    
    func successGetListMovieWithPage() {
        self.isLoadMore = true
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func handleError(error: ResponseError) {
        guard let status = error.statusCode else { return }
        guard let message = error.statusMessage else { return }
        if status == 8 {
            Alert.instance.oneOption(this: self, title: "NOTIFICATION", content: message , titleButton: "OK") {() in }
        } else {
            Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
        }
    }
}
