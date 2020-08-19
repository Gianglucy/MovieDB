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
    
    @IBOutlet weak var imvUser: UIImageView!
    @IBOutlet weak var viewLanguage: UIView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewAdult: UIView!
    @IBOutlet weak var lblAdult: UILabel!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    
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
        self.imvUser.contentMode = .scaleAspectFill
        self.imvUser.image = UIImage(named: "ic_avatar_red")
        self.imvUser.layer.cornerRadius = self.imvUser.layer.bounds.width / 2
        
        self.viewLanguage.layer.cornerRadius = CGFloat(Constants.cornerRadius)
        self.viewLanguage.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.viewLanguage.clipsToBounds = true
        self.lblLanguage.text = "---"
        
        self.viewName.layer.cornerRadius = CGFloat(Constants.cornerRadius)
        self.viewName.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.viewName.clipsToBounds = true
        self.lblName.text = "---"
        
        self.viewAdult.layer.cornerRadius = CGFloat(Constants.cornerRadius)
        self.viewAdult.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.viewAdult.clipsToBounds = true
        self.lblAdult.text = "---"
        
        self.viewUserName.layer.cornerRadius = CGFloat(Constants.cornerRadius)
        self.viewUserName.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        self.viewUserName.clipsToBounds = true
        self.lblUserName.text = "---"
    }
    
    func requestUser(sessionID: String) {
        let parameters: [String: String] = ["session_id": sessionID]
//        print("parameters===== \(parameters)")
        let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
        AF.request(ServerPath.accountDetail + ServerPath.apiKey, method: .get, parameters: parameters, headers: headers).validate().response{ response in
            switch response.result {
            case .success:
                let userData = try? JSONDecoder().decode(User.self, from: response.data!)
                self.dataUser = userData
//                print("HHHHHIIIIIIIII= \(self.dataUser)")
                DispatchQueue.main.async {
                    self.lblLanguage.text = self.dataUser?.iso31661
                    self.lblAdult.text = self.dataUser?.includeAdult?.description
                    self.lblName.text = self.dataUser?.name
                    self.lblUserName.text = self.dataUser?.username
//                    self.imvUser.image = self.dataUser?.avatar?.hash ?? UIImage(named: "ic_avatar_red")
                }
            case let .failure(error):
                self.alert(title: "ERROR", content: error.errorDescription!)
            }
        }
    }
    
    func alert(title: String, content: String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
