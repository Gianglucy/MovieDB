//
//  UserProfileModel.swift
//  MovieDB
//
//  Created by Apple on 9/17/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

protocol UserProfileModelDelegate {
    func handleError(error: ResponseError)
}

class UserProfileViewModel {
    var delegate: UserProfileModelDelegate?
    let defaults = UserDefaults.standard
    
    func requestUser(sessionID: String) {
        AuthService.shared.getUserDetail(sessionID: sessionID){ (result) in
            switch result {
            case .success(let data):
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
            case .failure(let error):
                guard let status = error.statusCode else { return }
                guard let message = error.statusMessage else { return }
                Alert.instance.oneOption(this: self, title: "ERROR\(status)", content: message , titleButton: "OK") {() in }
                self.delegate?.handleError(error: error)
            }
        }
    }
    
}
