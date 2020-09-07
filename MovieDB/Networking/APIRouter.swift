//
//  APIRouter.swift
//  MovieDB
//
//  Created by Apple on 8/20/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation
import Alamofire

enum MovieAPI {
    case getToken
    case getTokenByLogin
    case requestCreateSession
    case getUserDetail
    case deleteSession
    case requestListMovie
    case requestListMovieWithPage(page: Int)
    case getMovieDetail(id: Int)
    case getCreatedList(page: Int, accountID: String)
    case createList(sessionID: String)
    case deleteList(sessionID: String, listID: Int)
    case getDetailList(listID: Int)
    case addMovie(listID: Int, sessionID: String)
    case deleteMovie(listID: Int, sessionID: String)
    case rateMovie(movieID: Int, sessionID: String)
    case getAccountState(movieID: Int, sessionID: String)
}

extension MovieAPI: TargetType {
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
    
    var path: String {
        switch self {
        case .getToken:
            return "/authentication/token/new?api_key=\(ServerPath.apiKey)"
        case .getTokenByLogin:
            return "/authentication/token/validate_with_login?api_key=\(ServerPath.apiKey)"
        case .requestCreateSession:
            return "/authentication/session/new?api_key=\(ServerPath.apiKey)"
        case .getUserDetail:
            return "/account?api_key=\(ServerPath.apiKey)"
        case .deleteSession:
            return "/authentication/session?api_key=\(ServerPath.apiKey)"
        case .requestListMovie:
            return "/movie/top_rated?api_key=\(ServerPath.apiKey)&language=en-US&page=1"
        case .requestListMovieWithPage(let page):
            return "/movie/top_rated?api_key=\(ServerPath.apiKey)&language=en-US&page=\(page)"
        case .getMovieDetail(let id):
            return "/movie/\(id)?api_key=\(ServerPath.apiKey)&language=en-US"
        case .getCreatedList(let page,let accountID):
            return "/account/\(accountID)/lists?api_key=\(ServerPath.apiKey)&language=en-US&page=\(page)"
        case .deleteList(let sessionID, let listID):
            return "/list/\(listID)?api_key=\(ServerPath.apiKey)&session_id=\(sessionID)"
        case .createList(let sessionID):
            return "/list?api_key=\(ServerPath.apiKey)&session_id=\(sessionID)"
        case .getDetailList(let listID):
            return "/list/\(listID)?api_key=\(ServerPath.apiKey)&language=en-US"
        case .addMovie(let listID, let sessionID):
            return "/list/\(listID)/add_item?api_key=\(ServerPath.apiKey)&session_id=\(sessionID)"
        case .deleteMovie(let listID, let sessionID):
            return "/list/\(listID)/remove_item?api_key=\(ServerPath.apiKey)&session_id=\(sessionID)"
        case .rateMovie(let movieID, let sessionID):
            return "/movie/\(movieID)/rating?api_key=\(ServerPath.apiKey)&session_id=\(sessionID)"
        case .getAccountState(let movieID, let  sessionID):
            return "/movie/\(movieID)/account_states?api_key=\(ServerPath.apiKey)&session_id=\(sessionID)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getToken,
             .getUserDetail,
             .requestListMovie,
             .requestListMovieWithPage,
             .getMovieDetail,
             .getCreatedList,
             .getDetailList,
             .getAccountState:
            return .get
        case .getTokenByLogin,
             .requestCreateSession,
             .createList,
             .addMovie,
             .deleteMovie,
             .rateMovie:
            return .post
        case .deleteSession,
             .deleteList:
            return .delete
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getToken,
             .requestListMovie,
             .requestListMovieWithPage,
             .getMovieDetail:
            return ["Content-Type": "application/json"]
        case .getTokenByLogin,
             .requestCreateSession,
             .getUserDetail,
             .deleteSession,
             .getCreatedList:
            return [.authorization(bearerToken: ServerPath.accessToken)]
        case .createList,
             .addMovie,
             .deleteMovie,
             .rateMovie:
            return ["Content-Type": "application/json;charset=utf-8"]
        case .deleteList,
             .getDetailList,
             .getAccountState:
            return nil
        }
    }
    
    var url: URL {
        return URL(string: self.baseURL + self.path)!
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getToken,
             .getTokenByLogin,
             .requestCreateSession,
             .deleteSession,
             .requestListMovie,
             .requestListMovieWithPage,
             .getMovieDetail,
             .createList,
             .addMovie,
             .deleteMovie,
             .rateMovie:
            return JSONEncoding.default
        case .getUserDetail,
             .deleteList,
             .getCreatedList,
             .getDetailList,
             .getAccountState:
            return URLEncoding.default
        }
    }
}
