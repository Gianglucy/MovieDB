//
//  UserProfileModel.swift
//  MovieDB
//
//  Created by Apple on 9/17/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

protocol UserProfileViewModelDelegate {
    func handleError(error: ResponseError)
    func successRequestUser(data: User)
}

class UserProfileViewModel {
    var delegate: UserProfileViewModelDelegate?
    let defaults = UserDefaults.standard
    
    func requestUser(sessionID: String) {
        AuthService.shared.getUserDetail(sessionID: sessionID){ (result) in
            switch result {
            case .success(let data):
                guard let user = data else { return }
                self.delegate?.successRequestUser(data: user)
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                self.delegate?.handleError(error: error)
            }
        }
    }
    
}
