//
//  ServerPath.swift
//  MovieDB
//
//  Created by Apple on 8/18/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

struct ServerPath {
    static let apiKey = "bbc473cc53a42cbc333fea4235662554"
    static let apiSessionID = "https://api.themoviedb.org/3/authentication/session/new?api_key="
    static let apiLogin = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key="
    static let apiURL = "http://api.themoviedb.org/3/movie/upcoming?api_key="
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    static let requestToken = "https://api.themoviedb.org/3/authentication/token/new?api_key="
    static let accountDetail = "https://api.themoviedb.org/3/account?api_key="
    static let deleteSession = "https://api.themoviedb.org/3/authentication/session?api_key="
    
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYmM0NzNjYzUzYTQyY2JjMzMzZmVhNDIzNTY2MjU1NCIsInN1YiI6IjVmMWUyOTBhMGJiMDc2MDAzNWY3ZjA3ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dEbn-emvUInRLvVwEzCsU0kj-tRz2PrOfaE2u3VZhIo"
}
