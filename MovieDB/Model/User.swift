//
//  User.swift
//  MovieDB
//
//  Created by Apple on 8/19/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

struct User: Codable {
    var avatar: Gravatar?
    var id: Int?
    var country: String?
    var language: String?
    var name: String?
    var includeAdult: Bool?
    var username: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case language = "iso_639_1"
        case country = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}

struct Gravatar: Codable {
    var hash: String?
    
    enum CodingKeys: String, CodingKey {
        case hash
    }
}
