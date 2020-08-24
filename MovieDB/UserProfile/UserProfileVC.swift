//
//  UserProfileVC.swift
//  MovieDB
//
//  Created by Apple on 8/18/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit
import Alamofire

class UserProfileVC: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adultView: UIView!
    @IBOutlet weak var adultLabel: UILabel!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    let defaults = UserDefaults.standard
    var dataUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) {
            requestUser(sessionID: sessionID)
        }
        setupUI()
    }
    
    func setupUI() {
        self.title = "User Profile"
        
        self.view.backgroundColor = Colors.background
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.image = UIImage(named: "ic_avatar_red")
        self.userImageView.layer.cornerRadius = self.userImageView.layer.bounds.width / 2
        
        self.languageView.layer.cornerRadius = Constants.cornerRadius
        self.languageView.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.languageView.clipsToBounds = true
        self.languageLabel.text = "---"
        
        self.nameView.layer.cornerRadius = Constants.cornerRadius
        self.nameView.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.nameView.clipsToBounds = true
        self.nameLabel.text = "---"
        
        self.adultView.layer.cornerRadius = Constants.cornerRadius
        self.adultView.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.adultView.clipsToBounds = true
        self.adultLabel.text = "---"
        
        self.userNameView.layer.cornerRadius = Constants.cornerRadius
        self.userNameView.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.userNameView.clipsToBounds = true
        self.userNameLabel.text = "---"
        
        self.logoutButton.backgroundColor = Colors.organgeCustome
        self.logoutButton.layer.cornerRadius = Constants.cornerRadius
    }
    
    func requestUser(sessionID: String) {
        let parameters: [String: String] = ["session_id": sessionID]
        let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
        AuthService.instance.requestUserDetail(url: ServerPath.accountDetail + ServerPath.apiKey, parameters: parameters, headers: headers){ isSuccess, data, error in
            if isSuccess {
                self.dataUser = data
                DispatchQueue.main.async {
                    self.languageLabel.text = self.dataUser?.language
                    self.adultLabel.text = self.dataUser?.includeAdult?.description
                    self.nameLabel.text = self.dataUser?.name
                    self.userNameLabel.text = self.dataUser?.username
                }
            } else {
                Alert.instance.oneOption(this: self, title: "ERROR", content: error!, titleButton: "OK") {() in }
            }
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        Alert.instance.twoOption(this: self, title: "Notification", content: "Do you want to logout ?", titleButtonFirst: "Yes", titleButtonSecond: "No",
        first: {() -> () in
            if let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) {
                let parameters: [String: String] = ["session_id": sessionID]
                let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
                AuthService.instance.deleteSession(url: ServerPath.deleteSession + ServerPath.apiKey, parameters: parameters, headers: headers){ isSuccess, data, error in
                    if isSuccess {
                        let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                        let keywindow = UIApplication.shared.windows.first!
                        keywindow.rootViewController = loginVC
                        self.defaults.set(false, forKey: defaultsKey.loginStatus)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Alert.instance.oneOption(this: self, title: "ERROR", content: error!, titleButton: "OK") {() in }
                    }
                }
            }
        },
        second: {() -> () in
            
        })
    }
}
