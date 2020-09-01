//
//  List.swift
//  MovieDB
//
//  Created by Apple on 8/28/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

struct DataList: Codable {
    var page: Int?
    var results: [List]?
    var totalPages: Int?
    var totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct List: Codable {
    var description: String?
    var favoriteCount: Int?
    var id: Int?
    var itemCount: Int?
    var language: String?
    var listType: String?
    var name: String?
    var posterPath: String?
    var createdBy: String?
    var items: [Movie]?
    
    enum CodingKeys: String, CodingKey {
        case description
        case favoriteCount = "favorite_count"
        case id
        case itemCount = "item_count"
        case language = "iso_639_1"
        case listType = "list_type"
        case name
        case posterPath = "poster_path"
        case createdBy = "created_by"
        case items
    }
}

struct ResponseList: Codable {
    var statusMessage: String?
    var success: Bool?
    var statusCode: Int?
    var listId: Int?
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case success
        case statusCode = "status_code"
        case listId = "list_id"
    }
}
