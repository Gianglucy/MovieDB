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
        let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
        AF.request(ServerPath.requestToken + ServerPath.apiKey, method: .get, headers: headers).validate().responseJSON{ response in
            switch response.result {
            case .success:
                let tokenData = try? JSONDecoder().decode(Session.self, from: response.data!)
                guard let result = tokenData?.requestToken else { return }
                self.defaults.set(result, forKey: defaultsKey.token)
                self.createRequestTokenString(token: result)
            case let .failure(error):
                self.alert(title: "ERROR", content: error.errorDescription!)
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
        AF.request(ServerPath.apiLogin + ServerPath.apiKey, method: .post, parameters: parameters, headers: headers).validate().response{ response in
            switch response.result {
            case .success:
                let loginData = try? JSONDecoder().decode(Session.self, from: response.data!)
                guard let tokenRequest = loginData?.requestToken else { return }
                self.createSession(token: tokenRequest)
            case let .failure(error):
                self.alert(title: "ERROR", content: error.errorDescription!)
            }
        }
    }
    
    func createSession(token: String) {
        let parameters: [String: String] = ["request_token": token]
        let headers: HTTPHeaders = [.authorization(bearerToken: ServerPath.accessToken)]
        AF.request(ServerPath.apiSessionID + ServerPath.apiKey, method: .post, parameters: parameters, headers: headers).validate().response{ response in
            switch response.result {
            case .success:
                let sessionData = try? JSONDecoder().decode(Session.self, from: response.data!)
                guard let sessionID = sessionData?.sessionId else { return }
//                print("============ \(sessionID)")
                self.defaults.set(sessionID, forKey: defaultsKey.sessionID)
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
