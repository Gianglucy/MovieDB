//
//  Token.swift
//  MovieDB
//
//  Created by Apple on 8/18/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

struct Session: Codable {
    var success: Bool?
    var expiresAt: String?
    var requestToken: String?
    var sessionId: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case sessionId = "session_id"
    }
}
