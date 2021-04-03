//
//  HomeViewModel.swift
//  MovieDB
//
//  Created by Apple on 9/16/20.
//  Copyright © 2020 NguyenDucLuu. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate {
    func handleError(error: ResponseError)
    func successGetListMovieWithPage()
    func successGetListMovie()
    func addMovieSuccess(data: ResponseError)
}

class HomeViewModel {
    var delegate: HomeViewModelDelegate?
    let defaults = UserDefaults.standard
    var movieData: [Movie]?
    
    func requestToken() {
        AuthService.shared.getToken(){ (result) in
            switch result {
            case .success(let success):
                guard let requestTokenString = success?.requestToken else { return }
                self.defaults.set(requestTokenString, forKey: defaultsKey.token)
                self.createRequestTokenString(token: requestTokenString)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func createRequestTokenString(token: String) {
        guard let userName = self.defaults.string(forKey: defaultsKey.iD) else { return }
        guard let passWord = self.defaults.string(forKey: defaultsKey.password) else { return }
        AuthService.shared.getTokenByLogin(userName: userName, passWord: passWord, token: token){ (result) in
            switch result {
            case .success(let data):
                guard let tokenLoginRequest = data?.requestToken else { return }
                self.defaults.set(tokenLoginRequest, forKey: defaultsKey.token)
                self.createSessionID(token: tokenLoginRequest)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func createSessionID(token: String) {
        AuthService.shared.requestCreateSession(token: token){ (result) in
            switch result {
            case .success(let data):
                guard let sessionID = data?.sessionId else { return }
                print("=))))))) \(sessionID)")
                self.defaults.set(sessionID, forKey: defaultsKey.sessionID)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func getListMovieWithPage(page: Int) {
        AuthService.shared.requestListMovieWithPage(page: page){ (result) in
            switch result {
            case .success(let data):
                guard let data = data?.results! else { return }
                self.movieData! += data
                self.delegate?.successGetListMovieWithPage()
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func getListMovie( completion:@escaping () -> Void ) {
        AuthService.shared.requestListMovie(){ (result) in
            switch result {
            case .success(let data):
                self.movieData = data?.results
                self.delegate?.successGetListMovie()
                completion()
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
    
    func addMovie(listID: Int, sessionID: String, movieID: Int) {
        AuthService.shared.addMovie(listID: listID, sessionID: sessionID, movieID: movieID){ (result) in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self.delegate?.addMovieSuccess(data: data)
            case .failure(let error):
                self.delegate?.handleError(error: error)
            }
        }
    }
}
