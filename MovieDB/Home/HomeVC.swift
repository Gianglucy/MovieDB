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
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestToken()
    }
    
    func requestToken() {
        AuthService.instance.requestToken(url: ServerPath.requestToken + ServerPath.apiKey){ isSuccess, data, error in
            if isSuccess {
                guard let requestTokenString = data?.requestToken else { return }
                self.defaults.set(requestTokenString, forKey: defaultsKey.token)
                self.createRequestTokenString(token: requestTokenString)
            } else {
                Alert.instance.oneOption(this: self, title: "ERROR", content: error!, titleButton: "OK") {() in }
            }
        }
    }
    
    func createRequestTokenString(token: String) {
        guard let userName = self.defaults.string(forKey: defaultsKey.iD) else { return }
        guard let password = self.defaults.string(forKey: defaultsKey.password) else { return }
        let parameters: [String: String] = [
            "username": userName,
            "password": password,
            "request_token": token
        ]
        let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
        AuthService.instance.requestTokenByLogin(url: ServerPath.apiLogin + ServerPath.apiKey, parameters: parameters, headers: headers){isSuccess, data, error in
            if isSuccess {
                guard let tokenLoginRequest = data?.requestToken else { return }
                self.defaults.set(tokenLoginRequest, forKey: defaultsKey.token)
                self.createSessionID(token: tokenLoginRequest)
            } else {
                Alert.instance.oneOption(this: self, title: "ERROR", content: error!, titleButton: "OK") {() in }
            }
        }
    }
    
    func createSessionID(token: String) {
        let parameters: [String: String] = ["request_token": token]
        let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
        AuthService.instance.requestCreateSession(url: ServerPath.apiSessionID + ServerPath.apiKey, parameters: parameters, headers: headers){isSuccess, data, error in
            if isSuccess {
                guard let sessionID = data?.sessionId else { return }
                self.defaults.set(sessionID, forKey: defaultsKey.sessionID)
//                print("000000000000====>> \(sessionID)")
            } else {
                Alert.instance.oneOption(this: self, title: "ERROR", content: error!, titleButton: "OK") {() in }
            }
        }
    }
}
