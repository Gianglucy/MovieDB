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
    
    var loginViewModel: LoginViewModel?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVM()
        requestToken()
        setupUI()
    }
    
    func setupVM() {
        loginViewModel = LoginViewModel()
        loginViewModel?.delegate = self
    }
    
    func requestToken() {
        loginViewModel?.requestToken()
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
                guard let userName = userNameTextField.text else { return }
                guard let passWord = passTextField.text else { return }
                loginViewModel?.login(userName: userName, passWord: passWord, token: token)
            } else {
                Alert.instance.oneOption(this: self, title: "ERROR", content: "Connected fail!!!", titleButton: "OK") {() in }
            }
        }
    }
}

extension LoginVC: LoginViewModelDelegate {
    func loginSuccess() {
        self.defaults.set(self.userNameTextField.text, forKey: defaultsKey.iD)
        self.defaults.set(self.passTextField.text, forKey: defaultsKey.password)
        self.defaults.set(true, forKey: defaultsKey.loginStatus)
        Alert.instance.oneOption(this: self, title: "Successful", content: "SignUp successful", titleButton: "OK") {() in }
        let tabBarVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
        let keywindow = UIApplication.shared.windows.first!
        keywindow.rootViewController = tabBarVC
    }
    
    func handleError(error: ResponseError) {
        guard let status = error.statusCode else { return }
        guard let message = error.statusMessage else { return }
        Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
    }
}
