//
//  UserProfileVC.swift
//  MovieDB
//
//  Created by Apple on 8/18/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

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
    var userProfileVM: UserProfileViewModel?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVM()
        if let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) {
            userProfileVM?.requestUser(sessionID: sessionID)
        }
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupVM() {
        userProfileVM = UserProfileViewModel()
        userProfileVM?.delegate = self
    }
    
    func setupUI() {
        self.title = "User Profile"
        let rightBarButton = UIBarButtonItem(title: "List", style: .done, target: self, action: #selector(list))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
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
    
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    @objc func list() {
        let listVC = ListVC(nibName: "ListVC", bundle: nil)
        navigationController?.pushViewController(listVC, animated: true)
    }
    
//    func requestUser(sessionID: String) {
//        AuthService.shared.getUserDetail(sessionID: sessionID){ (result) in
//            switch result {
//            case .success(let data):
//                self.dataUser = data
//                let user = Users()
//                user.avatar?.url = data?.avatar?.hash ?? ""
//                user.country = data?.country
//                user.id = data?.id ?? 0
//                user.language = data?.language
//                user.name = data?.name
//                user.includeAdult = data?.includeAdult ?? false
//                user.username = data?.username
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.add(user)
//                }
//                self.defaults.set(data?.id, forKey: defaultsKey.accountID)
//                DispatchQueue.main.async {
//                    self.languageLabel.text = self.dataUser?.language
//                    self.adultLabel.text = self.dataUser?.includeAdult?.description
//                    self.nameLabel.text = self.dataUser?.name
//                    self.userNameLabel.text = self.dataUser?.username
//                }
//            case .failure(let error):
//                guard let status = error.statusCode else { return }
//                guard let message = error.statusMessage else { return }
//                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
//            }
//        }
//    }
    
    @IBAction func logout(_ sender: UIButton) {
        Alert.instance.twoOption(this: self, title: "Notification", content: "Do you want to logout ?", titleButtonFirst: "Yes", titleButtonSecond: "No",
                                 first: {() -> () in
                                    if let sessionID = self.defaults.string(forKey: defaultsKey.sessionID) {
                                        
                                        AuthService.shared.deleteSession(sessionID: sessionID){ (result) in
                                            switch result {
                                            case .success:
                                                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                                                let keywindow = UIApplication.shared.windows.first!
                                                keywindow.rootViewController = loginVC
                                                self.defaults.set(false, forKey: defaultsKey.loginStatus)
                                                self.dismiss(animated: true, completion: nil)
                                            case .failure(let error):
                                                guard let status = error.statusCode else { return }
                                                guard let message = error.statusMessage else { return }
                                                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                                            }
                                        }
                                    }
        },
                                 second: {() -> () in
                                    
        })
    }
}

extension UserProfileVC: UserProfileViewModelDelegate{
    func successRequestUser(data: User) {
        self.dataUser = data
        let user = Users()
        user.avatar?.url = data.avatar?.hash ?? ""
        user.country = data.country
        user.id = data.id ?? 0
        user.language = data.language
        user.name = data.name
        user.includeAdult = data.includeAdult ?? false
        user.username = data.username
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
        self.defaults.set(data.id, forKey: defaultsKey.accountID)
        DispatchQueue.main.async {
            self.languageLabel.text = self.dataUser?.language
            self.adultLabel.text = self.dataUser?.includeAdult?.description
            self.nameLabel.text = self.dataUser?.name
            self.userNameLabel.text = self.dataUser?.username
        }
    }
    
    func handleError(error: ResponseError) {
        guard let status = error.statusCode else { return }
        guard let message = error.statusMessage else { return }
        Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
    }
}
