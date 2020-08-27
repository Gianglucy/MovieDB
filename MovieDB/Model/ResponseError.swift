//
//  ResponseError.swift
//  MovieDB
//
//  Created by Apple on 8/26/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation
import Alamofire

class ResponseError: Codable, Error {
    var statusCode: Int?
    var statusMessage: String?
    var success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
    }
}
