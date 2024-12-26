//
//  MainViewModel.swift
//  NBC_Netflix
//
//  Created by 전성규 on 12/26/24.
//

import Foundation
import RxSwift

final class MainViewModel {
    private let apiKey = "b1afca5a9b8c24f2719494a27d6cd0de"
    
    private let disposeBag = DisposeBag()
    
    let popularMovieSubject = BehaviorSubject(value: [Movie]())
    let topRatedMovieSubject = BehaviorSubject(value: [Movie]())
    let popularTVShowSubject = BehaviorSubject(value: [Movie]())
    
    init() {
        self.fetchPopularMovie()
        self.fetchTopRatedMovie()
        self.fetchUpcomingMovie()
    }
    
    private func fetchPopularMovie() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)") else { return popularMovieSubject.onError(NetworkError.invalidURL) }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (movieResponse: MovieResponse) in
                    self?.popularMovieSubject.onNext(movieResponse.results)
                }, onFailure: { [weak self] error in
                    self?.popularMovieSubject.onError(error)
                }).disposed(by: disposeBag)
    }
    
    private func fetchTopRatedMovie() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)") else {
            topRatedMovieSubject.onError(NetworkError.invalidURL)
            return
        }
        
        NetworkManager.shared.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (movieResponse: MovieResponse) in
                    self?.topRatedMovieSubject.onNext(movieResponse.results)
                }, onFailure: { [weak self] error in
                    self?.topRatedMovieSubject.onError(error)
                }).disposed(by: disposeBag)
    }
    
    func fetchUpcomingMovie() {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)") else {
            popularTVShowSubject.onError(NetworkError.invalidURL)
            return
        }
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (movieResponse: MovieResponse) in
                
                self?.popularTVShowSubject.onNext(movieResponse.results)
            }, onFailure: { [weak self] error in
                self?.popularTVShowSubject.onError(error)
            }).disposed(by: disposeBag)
    }
}
