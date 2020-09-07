//
//  RateVC.swift
//  MovieDB
//
//  Created by Apple on 9/3/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit

class RateVC: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var starOneImageView: UIImageView!
    @IBOutlet weak var starTwoImageView: UIImageView!
    @IBOutlet weak var starThreeImageView: UIImageView!
    @IBOutlet weak var starFourImageView: UIImageView!
    @IBOutlet weak var starFiveImageView: UIImageView!
    @IBOutlet weak var starSixImageView: UIImageView!
    @IBOutlet weak var starSevenImageView: UIImageView!
    @IBOutlet weak var starEightImageView: UIImageView!
    @IBOutlet weak var starNineImageView: UIImageView!
    @IBOutlet weak var starTenImageView: UIImageView!
    let defaults = UserDefaults.standard
    var movie: Movie?
    var rateValue: Double = 0
    
    var starArray:[UIImageView]?
    var widthAllStar: CGFloat?
    let spacing: CGFloat = 16
    var starAt: Int = 0
    var isHalf: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        starArray = [starOneImageView, starTwoImageView, starThreeImageView, starFourImageView, starFiveImageView, starSixImageView, starSevenImageView, starEightImageView, starNineImageView, starTenImageView]
        widthAllStar = view.bounds.width - (spacing * 11)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        rateButton.setTitleColor(.white, for: .normal)
        rateButton.backgroundColor = .none
        rateButton.layer.cornerRadius = Constants.cornerRadius
        rateButton.isEnabled = false
        
        self.askLabel.text = "How would you rate \(movie?.title ?? "")"
        let queue = DispatchQueue(label: "loadImage",qos: .background)
        queue.async {
            if let pathURL: String = self.movie?.posterPath {
                let url = URL(string: ServerPath.imageURL + pathURL)
                do {
                    let data = try Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        self.view.backgroundColor = UIColor(patternImage: UIImage(data: data)!)
                        self.posterImageView.image = UIImage(data: data)
                    }
                } catch {}
            } else {
                return
            }
        }
        // set blur
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
        let panToStarRatingLabel = UIPanGestureRecognizer(target: self, action: #selector(panStarLabel))
        starStackView.isUserInteractionEnabled = true
        starStackView.addGestureRecognizer(panToStarRatingLabel)
        
        let tapToStarRatingLabel = UITapGestureRecognizer(target: self, action: #selector(panStarLabel))
        tapToStarRatingLabel.numberOfTapsRequired = 1
        starStackView.addGestureRecognizer(tapToStarRatingLabel)
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func rateMovie(_ sender: UIButton) {
        guard let movieID = movie?.id else { return }
        guard let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) else { return }
        AuthService.shared.rateMovie(movieID: movieID, sessionID: sessionID, rateValue: rateValue){(result) in
            switch result {
            case .success(let data):
                guard let message = data?.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "SUCCESS", content: message , titleButton: "OK") {() in
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
            }
        }
    }
    
    @objc func panStarLabel(sender: UIPanGestureRecognizer){
        let locationView = sender.location(in: self.view) // your finger position
        
        rateButton.backgroundColor = .cyan
        rateButton.isEnabled = true
        
        switch locationView.x {
        case spacing...0.5 * widthAllStar!/10 + 8 + 0.5 * spacing:
            starAt = 1
            isHalf = true
            rateValue = 0.5
        case 0.5 * widthAllStar!/10 + 8 + 0.5 * spacing...widthAllStar!/10 + 8 + spacing:
            starAt = 1
            isHalf = false
            rateValue = 1
        case widthAllStar!/10 + 8 + spacing...1.5 * widthAllStar!/10 + 8 + 1.5 * spacing:
            starAt = 2
            isHalf = true
            rateValue = 1.5
        case 1.5 * widthAllStar!/10 + 8 + 1.5 * spacing...2 * widthAllStar!/10 + 8 + 2 * spacing:
            starAt = 2
            isHalf = false
            rateValue = 2
        case 2 * widthAllStar!/10 + 8 + 2 * spacing...2.5 * widthAllStar!/10 + 8 + 2.5 * spacing:
            starAt = 3
            isHalf = true
            rateValue = 2.5
        case 2.5 * widthAllStar!/10 + 8 + 2.5 * spacing...3 * widthAllStar!/10 + 8 + 3 * spacing:
            starAt = 3
            isHalf = false
            rateValue = 3
        case 3 * widthAllStar!/10 + 8 + 3 * spacing...3.5 * widthAllStar!/10 + 8 + 3.5 * spacing:
            starAt = 4
            isHalf = true
            rateValue = 3.5
        case 3.5 * widthAllStar!/10 + 8 + 3.5 * spacing...4 * widthAllStar!/10 + 8 + 4 * spacing:
            starAt = 4
            isHalf = false
            rateValue = 4
        case 4 * widthAllStar!/10 + 8 + 4 * spacing...4.5 * widthAllStar!/10 + 8 + 4.5 * spacing:
            starAt = 5
            isHalf = true
            rateValue = 4.5
        case 4.5 * widthAllStar!/10 + 8 + 4.5 * spacing...5 * widthAllStar!/10 + 8 + 5 * spacing:
            starAt = 5
            isHalf = false
            rateValue = 5
        case 5 * widthAllStar!/10 + 8 + 5 * spacing...5.5 * widthAllStar!/10 + 8 + 5.5 * spacing:
            starAt = 6
            isHalf = true
            rateValue = 5.5
        case 5.5 * widthAllStar!/10 + 8 + 5.5 * spacing...6 * widthAllStar!/10 + 8 + 6 * spacing:
            starAt = 6
            isHalf = false
            rateValue = 6
        case 6 * widthAllStar!/10 + 8 + 6 * spacing...6.5 * widthAllStar!/10 + 8 + 6.5 * spacing:
            starAt = 7
            isHalf = true
            rateValue = 6.5
        case 6.5 * widthAllStar!/10 + 8 + 6.5 * spacing...7 * widthAllStar!/10 + 8 + 7 * spacing:
            starAt = 7
            isHalf = false
            rateValue = 7
        case 7 * widthAllStar!/10 + 8 + 7 * spacing...7.5 * widthAllStar!/10 + 8 + 7.5 * spacing:
            starAt = 8
            isHalf = true
            rateValue = 7.5
        case 7.5 * widthAllStar!/10 + 8 + 7.5 * spacing...8 * widthAllStar!/10 + 8 + 8 * spacing:
            starAt = 8
            isHalf = false
            rateValue = 8
        case 8 * widthAllStar!/10 + 8 + 8 * spacing...8.5 * widthAllStar!/10 + 8 + 8.5 * spacing:
            starAt = 9
            isHalf = true
            rateValue = 8.5
        case 8.5 * widthAllStar!/10 + 8 + 8.5 * spacing...9 * widthAllStar!/10 + 8 + 9 * spacing:
            starAt = 9
            isHalf = false
            rateValue = 9
        case 9 * widthAllStar!/10 + 8 + 9 * spacing...9.5 * widthAllStar!/10 + 8 + 9.5 * spacing:
            starAt = 10
            isHalf = true
            rateValue = 9.5
        case 9.5 * widthAllStar!/10 + 8 + 9.5 * spacing...10 * widthAllStar!/10 + 8 + 10 * spacing:
            starAt = 10
            isHalf = false
            rateValue = 10
        default:
            return
        }
        // restart stars
        for item in 0..<10 {
            self.starArray![item].image = UIImage(named: "ic_star_empty_cyan")
        }
        // set full star
        for item in 0...starAt - 1 {
            self.starArray![item].image = UIImage(named: "ic_star_cyan")
        }
        // set half star
        if isHalf {
            self.starArray![starAt - 1].image = UIImage(named: "ic_star_half_empty_cyan")
        }
    }
}
