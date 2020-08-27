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
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getToken,
             .getUserDetail,
             .requestListMovie,
             .requestListMovieWithPage,
             .getMovieDetail:
            return .get
        case .getTokenByLogin,
             .requestCreateSession:
            return .post
        case .deleteSession:
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
             .deleteSession:
            return [.authorization(bearerToken: ServerPath.accessToken)]
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
             .getMovieDetail:
            return JSONEncoding.default
        case .getUserDetail:
            return URLEncoding.default
        }
    }
}
