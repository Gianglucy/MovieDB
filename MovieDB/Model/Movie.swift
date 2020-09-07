//
//  Movie.swift
//  MovieDB
//
//  Created by Apple on 8/24/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: Int?
    var popularity: Float?
    var voteCount: Int?
    var video: Bool?
    var posterPath:String?
    var adult: Bool?
    var backdropPath: String?
    var originalLanguage: String?
    var originalTitle:String?
    var genreIds: [Int]?
    var title: String?
    var voteAverage: Float?
    var overview:String?
    var releaseDate: String?
    var belongsToCollection: Collections?
    var budget: Int?
    var genres: [Genres]?
    var homepage: String?
    var imdbId: String?
    var productionCompanies: [Company]?
    var productionCountries: [Country]?
    var revenue: Int?
    var runtime: Int?
    var spokenLanguages: [Languages]?
    var status: String?
    var tagline: String?
    var mediaType: String?
    var favorite: Bool?
    var rated: Bool?
    var watchlist: Bool?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case overview
        case popularity
        case voteCount = "vote_count"
        case video
        case id
        case adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case title
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case imdbId = "imdb_id"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case mediaType = "media_type"
        case favorite
        case rated
        case watchlist
        
    }
}

struct Rate: Codable {
    var  value: Double?
    
    enum CodingKeys: String, CodingKey {
        case value
    }
}

struct Languages: Codable {
    var name: String?
    var language: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case language = "iso_639_1"
    }
}

struct Country: Codable {
    var name: String?
    var country: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "iso_3166_1"
    }
}

struct Company: Codable {
    var id: Int?
    var name: String?
    var logoPath: String?
    var originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct Genres: Codable {
    var id: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

struct Collections: Codable {
    var id: Int?
    var name: String?
    var posterPath: String?
    var backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct Dates: Codable {
    var maximum: String?
    var minimum: String?
    
    enum CodingKeys: String, CodingKey {
        case maximum
        case minimum
    }
}

struct DataMovie: Codable {
    var results: [Movie]?
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var dates: Dates?
    
    enum CodingKeys: String, CodingKey {
        case results
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
