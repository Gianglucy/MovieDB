//
//  MovieCell.swift
//  MovieDB
//
//  Created by Apple on 8/24/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

protocol MovieCellProtocol: AnyObject {
    func passIdMovie(id: Int)
    func callAddItem(movieID: Int)
    func callDeleteItem(movieID: Int)
    func voteMovie(movie: Movie)
}

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var voteAverageView: UIView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var addListButton: UIButton!
    
    var movie: Movie?
    var imagePost: Data?
    let cache = NSCache<NSString, NSData>()
    weak var delegate: MovieCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.addListButton.tintColor = .cyan
        self.backgroundColor = Colors.background
        posterImageView.image = UIImage(named: "img_image")
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .white
        self.alpha = 0.1
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0,height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = Constants.cornerRadius
        
        self.voteAverageView.layer.cornerRadius = self.voteAverageView.layer.frame.width/3.2
        //add action
        posterImageView.isUserInteractionEnabled = true
        let tapPoster = UITapGestureRecognizer(target: self, action: #selector(self.touchPoster))
        posterImageView.addGestureRecognizer(tapPoster)
        
        voteAverageView.isUserInteractionEnabled = true
        let tapVoteAverage = UITapGestureRecognizer(target: self, action: #selector(self.touchVote))
        voteAverageView.addGestureRecognizer(tapVoteAverage)
    }
    
    @objc func touchPoster() {
        if let movie = self.movie {
            delegate?.passIdMovie(id: movie.id ?? 0)
        }
    }
    
    @objc func touchVote() {
        if let movie = self.movie {
            delegate?.voteMovie(movie: movie)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
    }
    
    @IBAction func addList(_ sender: UIButton) {
        if let movie = self.movie {
            delegate?.callAddItem(movieID: movie.id ?? 0)
            delegate?.callDeleteItem(movieID: movie.id ?? 0)
        }
    }
    
    func configCell(movie: Movie?) {
        if let dataMovie: Movie = movie {
            self.movie = dataMovie
        }
        
//        if let pathURL: String = movie.posterPath {
//            let url = URL(string: ServerPath.imageURL + pathURL)
//            do {
//                let data = try Data(contentsOf: url!)
//                cache.setObject(data as NSData, forKey: pathURL as NSString)
//            } catch { }
//        } else {
//            return
//        }
        
        voteAverageLabel.text = String(movie?.voteAverage ?? 0)
        
        titleLabel.text = movie?.originalTitle ?? "No title"
        overviewLabel.text = movie?.overview ?? "No decription"
        
        let queue = DispatchQueue(label: "loadImage",qos: .background)
        queue.async {
                        if let pathURL: String = movie?.posterPath {
                            let url = URL(string: ServerPath.imageURL + pathURL)
                            do {
                                let data = try Data(contentsOf: url!)
                                DispatchQueue.main.async {
                                    self.posterImageView.image = UIImage(data: data)
                                }
                            } catch {
            
                            }
                        } else {
                            return
                        }
//            if let dataImage = self.cache.object(forKey: movie.posterPath as! NSString) {
//                self.loadImage(image: dataImage as Data)
//            } else {
//                if let pathURL: String = movie.posterPath {
//                    let url = URL(string: ServerPath.imageURL + pathURL)
//                    do {
//                        let data = try Data(contentsOf: url!)
//                        self.cache.setObject(data as NSData, forKey: pathURL as NSString)
//                    } catch { }
//                } else {
//                    return
//                }
//            }
        }
    }
    
//    func loadImage(image: Data) {
//        DispatchQueue.main.async {
//            self.posterImageView.image = UIImage(data: image)
//        }
//    }
}
