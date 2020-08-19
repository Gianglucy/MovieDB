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
    var iso6391: String?
    var iso31661: String?
    var name: String?
    var includeAdult: Bool?
    var username: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case id
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
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
