//
//  PokemonNetworking.swift
//  DevmountainWorldControl
//
//  Created by Jayden Garrick on 3/10/21.
//

import UIKit

enum PokemonNetworkError: Error {
    case badURL
    case dataTaskError(Error)
    case noDataReturned
    case decodingError(Error)
    case badDataForImage
}

typealias ImageResponse = (Result<UIImage, PokemonNetworkError>) -> Void
typealias PokemonBackendResponse = (Result<[Pokemon], PokemonNetworkError>) -> Void

class PokemonNetworkingManager {

    enum Constants {
        static let baseURL = "https://api.pokemontcg.io/v1/cards"
        static let name = "name"
    }
    
    func fetchPokemon(with searchTerm: String, completion: @escaping PokemonBackendResponse) {
        // URL setup
        guard var url = URL(string: Constants.baseURL) else {
            completion(.failure(.badURL))
            return
        }
        url.addQueryParameter(Constants.name, value: searchTerm)
        
        // Data Task
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(.dataTaskError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noDataReturned))
                return
            }
            let jsonDecoder = JSONDecoder()
            do {
                let topLevel = try jsonDecoder.decode(TopLevelJSON.self, from: data)
                completion(.success(topLevel.cards))
            } catch(let error) {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    func fetchPokemonImage(with pokemon: Pokemon, completion: @escaping ImageResponse) {
        URLSession.shared.dataTask(with: pokemon.lowResolutionImageURL) { (data, _, error) in
            if let error = error {
                completion(.failure(.dataTaskError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noDataReturned))
                return
            }
            guard let image = UIImage(data: data) else {
                completion(.failure(.badDataForImage))
                return
            }
            completion(.success(image))
        }.resume()
    }
    
}

extension URL {
    mutating func addQueryParameter(_ queryItem: String, value: String) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        self = urlComponents.url!
    }
}
