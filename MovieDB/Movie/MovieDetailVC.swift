//
//  MovieDetailVC.swift
//  MovieDB
//
//  Created by Apple on 8/25/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDayLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    var MovieId: Int?
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetail()
        setupUI()
    }
    
    func setupUI() {
    }
    
    func getMovieDetail() {
        if let id = MovieId {
            AuthService.shared.getMovieDetail(id: id){ (result) in
                switch result {
                case .success(let data):
                    guard let data = data else { return }
                    let queue = DispatchQueue(label: "loadImage",qos: .background)
                    queue.async {
                        if let pathURL: String = data.backdropPath {
                            let url = URL(string: ServerPath.imageURL + pathURL)
                            do {
                                let data = try Data(contentsOf: url!)
                                DispatchQueue.main.async {
                                    self.backdropImageView.image = UIImage(data: data)
                                }
                            } catch {
                            }
                        } else {
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        if let date = data.releaseDate {
                            let firstSpace = date.firstIndex(of: "-") ?? date.endIndex
                            let year = date[..<firstSpace]
                            guard let title = data.title else { return }
                            guard let listCountries = data.productionCountries else { return }
                            var country: String = ""
                            for item in listCountries {
                                country += item.country ?? ""
                            }
                            self.titleLabel.text = title + " (\(year))"
                            self.releaseDayLabel.text = date.replacingOccurrences(of: "-", with: "/") + " " +  ( country == "" ? "" : "(\(country))")
                        }
                        self.statusLabel.text = data.status
                        self.languageLabel.text = data.originalLanguage
                        if let budget = data.budget {
                            self.budgetLabel.text = budget == 0 ? "-" : String(budget)
                        }
                        if let revenue = data.revenue {
                            self.revenueLabel.text = revenue == 0 ? "-" : String(revenue)
                        }
                        self.overviewLabel.text = data.overview
                    }
                case .failure(let error):
                    guard let status = error.statusCode else { return }
                    guard let message = error.statusMessage else { return }
                    Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                }
            }
        }
    }
}
