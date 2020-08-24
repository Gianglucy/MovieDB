//
//  APIRouter.swift
//  MovieDB
//
//  Created by Apple on 8/20/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation


import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    
    case getRequestToken
    case login(username: String, password: String, requestToken: String)
    case getUserDetails
  
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .getRequestToken:
            return .get
        case .login:
            return .post
        case .getUserDetails:
            return .get
        }
    }
    // MARK: - Parameters
     var parameters: RequestParams {
        switch self {
        case .getRequestToken:
            return .body([:])
        case .login(let username, let password, let requestToken):
            return .body(["username" : username, "password" : password, "request_token" : requestToken])
        case .getUserDetails:
            return .body([:])
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getRequestToken:
            return "/authentication/token/new?api_key=" + ServerPath.apiKey
        case .login:
            return "/authentication/token/validate_with_login?api_key=" + ServerPath.apiKey
        case .getUserDetails:
            return "/userDetailEndpoint"
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        switch parameters {
            
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            
        case .url(let params):
                let queryParams = params.map { pair  in
                    return URLQueryItem(name: pair.key, value: "\(pair.value)")
                }
                var components = URLComponents(string:url.appendingPathComponent(path).absoluteString)
                components?.queryItems = queryParams
                urlRequest.url = components?.url
        }
            return urlRequest
    }
}
