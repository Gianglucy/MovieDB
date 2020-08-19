//
//  LoginVC.swift
//  MovieDB
//
//  Created by Apple on 8/17/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    @IBOutlet weak var imvHeader: UIImageView!
    @IBOutlet weak var txfUserName: UITextField!
    @IBOutlet weak var txfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestToken()
        setupUI()
    }
    
    func requestToken() {
        
        let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
        AF.request(ServerPath.requestToken + ServerPath.apiKey, method: .get, headers: headers).validate().responseJSON{ response in
            
            switch response.result {
            case .success:
                let tokenData = try? JSONDecoder().decode(Session.self, from: response.data!)
                guard let result = tokenData?.requestToken else { return }
                self.defaults.set(result, forKey: defaultsKey.token)
            case let .failure(error):
                self.alert(title: "ERROR3", content: error.errorDescription!)
            }
            
        }
    }
    
    
    func setupUI() {
        self.view.backgroundColor = Colors.background
        imvHeader.image = #imageLiteral(resourceName: "MovieDB")
        imvHeader.contentMode = .scaleAspectFit
        txfUserName.placeholder = "User name"
        txfPass.placeholder = "Password"
        btnLogin.setTitleColor(.white, for: .normal)
        btnLogin.titleLabel?.font = .boldSystemFont(ofSize: CGFloat(Fonts.buttonText))
        btnLogin.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        
        let attributesPlaceholder: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: CGFloat(Fonts.placeholder)),
            .foregroundColor: Colors.blueCustome
        ]
        txfUserName.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: attributesPlaceholder)
        txfPass.isSecureTextEntry = true
        txfPass.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesPlaceholder)
        
        btnLogin.layer.cornerRadius = CGFloat(Constants.cornerRadius)
        btnLogin.layer.masksToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true) 
    }
    
    @IBAction func login(_ sender: UIButton) {
        if txfUserName.text!.isEmpty || txfPass.text!.isEmpty {
            self.alert(title: "Alert", content: "Please fill full!")
        } else {
            self.defaults.set(txfUserName.text, forKey: defaultsKey.iD)
            self.defaults.set(txfPass.text, forKey: defaultsKey.password)
            if let token = self.defaults.string(forKey: defaultsKey.token) {
                let parameters: [String: String] = [
                    "username": txfUserName.text!,
                    "password": txfPass.text!,
                    "request_token": token
                ]
                let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
                AF.request(ServerPath.apiLogin + ServerPath.apiKey, method: .post, parameters: parameters, headers: headers).validate().response{ response in
                    switch response.result {
                    case .success:
                        let loginData = try? JSONDecoder().decode(Session.self, from: response.data!)
                        guard let success = loginData?.success else { return }
                        self.defaults.set(success, forKey: defaultsKey.loginStatus)
                        self.alert(title: "Successful", content: "SignUp successful")
                        let tabBarVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                        let keywindow = UIApplication.shared.windows.first!
                        keywindow.rootViewController = tabBarVC
                    case let .failure(error):
                        self.alert(title: "ERROR", content: error.errorDescription!)
                    }
                }
            } else {
                alert(title: "Error", content: "Connect fail!!!")
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
