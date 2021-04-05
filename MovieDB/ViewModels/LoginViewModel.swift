//
//  LoginViewModel.swift
//  MovieDB
//
//  Created by Apple on 9/16/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate {
    func handleError(error: ResponseError)
    func loginSuccess()
}

class LoginViewModel {
    var delegate: LoginViewModelDelegate?
    let defaults = UserDefaults.standard
    
    func requestToken() {
        AuthService.shared.getToken(){ (result) in
            switch result {
            case .success(let success):
                guard let requestTokenString = success?.requestToken else { return }
                self.defaults.set(requestTokenString, forKey: defaultsKey.token)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func login(userName: String, passWord: String, token: String) {
        AuthService.shared.getTokenByLogin(userName: userName, passWord: passWord, token: token){ (result) in
            switch result {
            case .success:
                self.delegate?.loginSuccess()
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
}
