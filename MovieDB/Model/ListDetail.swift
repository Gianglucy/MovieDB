//
//  ListDetail.swift
//  MovieDB
//
//  Created by Apple on 8/31/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

struct ListDetail: Codable {
    var description: String?
    var favoriteCount: Int?
    var id: String?
    var createdBy: String?
    var items: [Movie]?
    var itemCount: Int?
    var language: String?
    var name: String?
    var posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case posterPath = "poster_path"
        case createdBy = "created_by"
        case items
        case description
        case favoriteCount = "favorite_count"
        case id
        case itemCount = "item_count"
        case language = "iso_639_1"
    }
}
