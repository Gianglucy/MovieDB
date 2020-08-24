//
//  AuthService.swift
//  MovieDB
//
//  Created by Apple on 8/20/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation
import Alamofire

//typealias CommonType<T> = (T)
//
//protocol AuthServiceDelegate {
//    func responseNetword(isSuccess: Bool, data: CommonType<Any>)
//}

//sunccess(aaa: Movie){}
//sunccess(aaa: User){}

//error(message: String){
//showError(message)
//}

//HomeViewModel.exampleAAA(params) chua 2 delegate success va error

class AuthService {
    
    static let instance = AuthService()
    typealias CompletionHandler<T> = (T)
    let defaults = UserDefaults.standard
    
    func requestToken(url: String, completion: @escaping (_ isSuccess: Bool, _ data: Session?, _ error: String?)->Void ) {
        AF.request(url, method: .get).validate().responseJSON{ response in
            switch response.result {
            case .success:
                do {
                    let session = try JSONDecoder().decode(Session.self, from: response.data!)
                    completion(true, session, nil)
                } catch let error {
                    print("===>> ERROR DECODE \(error)")
                }
            case let .failure(error):
                completion(false, nil, error.errorDescription ?? "error")
            }
        }
    }
    
    func requestTokenByLogin(url: String, parameters: [String: String], headers: HTTPHeaders?, completion: @escaping (_ isSuccess: Bool, _ data: Session?, _ error: String?)->Void ) {
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().response{ response in
            switch response.result {
            case .success:
                do {
                    let session = try JSONDecoder().decode(Session.self, from: response.data!)
                    completion(true, session, nil)
                } catch let error {
                    print("===>> ERROR DECODE \(error)")
                }
            case let .failure(error):
                completion(false, nil, error.errorDescription ?? "error")
            }
        }
    }
    
    func requestCreateSession(url: String, parameters: [String: String], headers: HTTPHeaders?, completion: @escaping (_ isSuccess: Bool, _ data: Session?, _ error: String?)->Void ) {
        AF.request(url, method: .post, parameters: parameters, headers: headers).validate().response{ response in
            switch response.result {
            case .success:
                do {
                    let session = try JSONDecoder().decode(Session.self, from: response.data!)
                    completion(true, session, nil)
                } catch let error {
                    print("===>> ERROR DECODE \(error)")
                }
            case let .failure(error):
                completion(false, nil, error.errorDescription ?? "error")
            }
        }
    }
    
    func requestUserDetail(url: String, parameters: [String: String], headers: HTTPHeaders?, completion: @escaping (_ isSuccess: Bool, _ data: User?, _ error: String?)->Void ) {
        AF.request(ServerPath.accountDetail + ServerPath.apiKey, method: .get, parameters: parameters, headers: headers).validate().response{ response in
            switch response.result {
            case .success:
                do {
                    let user = try? JSONDecoder().decode(User.self, from: response.data!)
                    completion(true, user, nil)
                } catch let error {
                    print("===>> ERROR DECODE \(error)")
                }
            case let .failure(error):
                completion(false, nil, error.errorDescription ?? "error")
            }
        }
    }
    
    func deleteSession(url: String, parameters: [String: String], headers: HTTPHeaders?, completion: @escaping (_ isSuccess: Bool, _ data: Session?, _ error: String?)->Void ) {
        AF.request(ServerPath.deleteSession + ServerPath.apiKey, method: .delete, parameters: parameters, headers: headers).validate().response{ response in
            switch response.result {
            case .success:
                do {
                    let session = try JSONDecoder().decode(Session.self, from: response.data!)
                    completion(true, session, nil)
                } catch let error {
                    print("===>> ERROR DECODE \(error)")
                }
            case let .failure(error):
                completion(false, nil, error.errorDescription ?? "error")
            }
        }
    }
    
}
