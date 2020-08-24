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
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestToken()
        setupUI()
    }
    
    func requestToken() {
        AuthService.instance.requestToken(url: ServerPath.requestToken + ServerPath.apiKey){isSuccess, data, error in
            if isSuccess {
                guard let requestTokenString = data?.requestToken else { return }
                self.defaults.set(requestTokenString, forKey: defaultsKey.token)
            } else {
                Alert.instance.oneOption(this: self, title: "ERROR", content: error!, titleButton: "OK") {() in }
            }
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = Colors.background
        logoImageView.image = #imageLiteral(resourceName: "MovieDB")
        logoImageView.contentMode = .scaleAspectFit
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: CGFloat(Fonts.buttonText))
        loginButton.setGradientBackground(colorOne: Colors.greenCustome, colorTwo: Colors.blueCustome)
        
        let attributesPlaceholder: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: CGFloat(Fonts.placeholder)),
            .foregroundColor: Colors.blueCustome
        ]
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: attributesPlaceholder)
        passTextField.isSecureTextEntry = true
        passTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesPlaceholder)
        
        loginButton.layer.cornerRadius = CGFloat(Constants.cornerRadius)
        loginButton.layer.masksToBounds = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true) 
    }
    
    @IBAction func login(_ sender: UIButton) {
        if userNameTextField.text!.isEmpty || passTextField.text!.isEmpty {
            Alert.instance.oneOption(this: self, title: "Alert", content: "Please fill full!", titleButton: "OK") {() in }
        } else {
            if let token = self.defaults.string(forKey: defaultsKey.token) {
                let parameters: [String: String] = [
                    "username": userNameTextField.text!,
                    "password": passTextField.text!,
                    "request_token": token
                ]
                let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
                AuthService.instance.requestTokenByLogin(url: ServerPath.apiLogin + ServerPath.apiKey, parameters: parameters, headers: headers){isSuccess, data, error in
                    if isSuccess {
                        self.defaults.set(self.userNameTextField.text, forKey: defaultsKey.iD)
                        self.defaults.set(self.passTextField.text, forKey: defaultsKey.password)
                        self.defaults.set(true, forKey: defaultsKey.loginStatus)
                        Alert.instance.oneOption(this: self, title: "Successful", content: "SignUp successful", titleButton: "OK") {() in }
                        let tabBarVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
                        let keywindow = UIApplication.shared.windows.first!
                        keywindow.rootViewController = tabBarVC
                    } else {
                        Alert.instance.oneOption(this: self, title: "ERROR", content: error!, titleButton: "OK") {() in }
                    }
                }
            } else {
                Alert.instance.oneOption(this: self, title: "ERROR", content: "Connect fail!!!", titleButton: "OK") {() in }
            }
        }
    }
}
