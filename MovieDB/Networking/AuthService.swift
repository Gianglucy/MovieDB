//
//  AuthService.swift
//  MovieDB
//
//  Created by Apple on 8/20/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    
    static let shared = AuthService()
    
    func getToken(completionHandler: @escaping (_ result: Result<Session?, ResponseError>)->()){
        APIManager.shared.call(type: MovieAPI.getToken){(result: Result<Session?, ResponseError>) in
            switch result {
            case .success(let session):
                completionHandler(.success(session))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getTokenByLogin( userName: String,passWord: String,token: String,completionHandler: @escaping (_ result: Result<Session?, ResponseError>)->()){
        let parameters: [String: String] = [
            "username": userName,
            "password": passWord,
            "request_token": token
        ]
        APIManager.shared.call(type: MovieAPI.getTokenByLogin, params: parameters){(result: Result<Session?, ResponseError>) in
            switch result {
            case .success(let session):
                completionHandler(.success(session))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func requestCreateSession( token: String,completionHandler: @escaping (_ result: Result<Session?, ResponseError>)->()){
        let parameters: [String: String] = [
            "request_token": token
        ]
        APIManager.shared.call(type: MovieAPI.requestCreateSession, params: parameters){(result: Result<Session?, ResponseError>) in
            switch result {
            case .success(let session):
                completionHandler(.success(session))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getUserDetail( sessionID: String, completionHandler: @escaping (_ result: Result<User?, ResponseError>)->()){
        let parameters: [String: String] = ["session_id": sessionID]
        APIManager.shared.call(type: MovieAPI.getUserDetail, params: parameters){(result: Result<User?, ResponseError>) in
            switch result {
            case .success(let user):
                completionHandler(.success(user))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func deleteSession( sessionID: String,completionHandler: @escaping (_ result: Result<Session?, ResponseError>)->()){
        let parameters: [String: String] = ["session_id": sessionID]
        APIManager.shared.call(type: MovieAPI.deleteSession, params: parameters){(result: Result<Session?, ResponseError>) in
            switch result {
            case .success(let session):
                completionHandler(.success(session))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func requestListMovie( completionHandler: @escaping (_ result: Result<DataMovie?, ResponseError>)->()){
        APIManager.shared.call(type: MovieAPI.requestListMovie){(result: Result<DataMovie?, ResponseError>) in
            switch result {
            case .success(let dataMovie):
                completionHandler(.success(dataMovie))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func requestListMovieWithPage( page: Int, completionHandler: @escaping (_ result: Result<DataMovie?, ResponseError>)->()){
        APIManager.shared.call(type: MovieAPI.requestListMovieWithPage(page: page)){(result: Result<DataMovie?, ResponseError>) in
            switch result {
            case .success(let dataMovie):
                completionHandler(.success(dataMovie))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getMovieDetail( id: Int, completionHandler: @escaping (_ result: Result<Movie?, ResponseError>)->()){
        APIManager.shared.call(type: MovieAPI.getMovieDetail(id: id)){(result: Result<Movie?, ResponseError>) in
            switch result {
            case .success(let movie):
                completionHandler(.success(movie))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getCreatedList( page: Int, accountID: String, sessionID: String, completionHandler: @escaping (_ result: Result<DataList?, ResponseError>)->()){
        let parameters: [String: String] = ["session_id": sessionID]
        APIManager.shared.call(type: MovieAPI.getCreatedList(page: page, accountID: accountID), params: parameters){(result: Result<DataList?, ResponseError>) in
            switch result {
            case .success(let dataList):
                completionHandler(.success(dataList))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func deleteList( listID: Int, sessionID: String, completionHandler: @escaping (_ result: Result<ResponseError?, ResponseError>)->()){
        APIManager.shared.call(type: MovieAPI.deleteList(sessionID: sessionID, listID: listID)){(result: Result<ResponseError?, ResponseError>) in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func createList( name: String, description: String? = "", sessionID: String, completionHandler: @escaping (_ result: Result<ResponseList?, ResponseError>)->()){
        let parameters: [String: String] = [
            "name": name,
            "description": description!,
            "language": "en"
        ]
        APIManager.shared.call(type: MovieAPI.createList(sessionID: sessionID), params: parameters){(result: Result<ResponseList?, ResponseError>) in
            switch result {
            case .success(let response):
                completionHandler(.success(response))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
