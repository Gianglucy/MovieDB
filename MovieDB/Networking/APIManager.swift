//
//  APIManager.swift
//  MovieDB
//
//  Created by Apple on 8/27/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    static var shared = APIManager()
    
    private init() { }
    
    func call<T>(type: TargetType, params: Parameters? = nil, completionHandler: @escaping (_ result: Result<T?, ResponseError>)->()) where T: Codable {
        
        AF.request(type.url,
                   method: type.httpMethod,
                   parameters: params,
                   encoding: type.encoding,
                   headers: type.headers)
            .validate()
            .responseJSON {data in
                switch data.result {
                case .success(_):
                    let decoder = JSONDecoder()
                    if let jsonData = data.data {
                        do {
                            let result = try decoder.decode(T.self, from: jsonData)
                            completionHandler(.success(result))
                        } catch {
                            print("==== Error Decoder ====")
                        }
                    }
                    break
                case .failure(_):
                    let decoder = JSONDecoder()
                    if let jsonData = data.data {
                        do {
                            let error = try decoder.decode(ResponseError.self, from: jsonData)
                            completionHandler(.failure(error))
                        } catch {
                            print("==== Error Unknown ====")
                        }
                    }
                    break
                }
        }
    }
}
