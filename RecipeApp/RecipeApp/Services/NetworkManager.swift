//
//  NetworkManager.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/19/24.
//


import Foundation

protocol NetworkManagerProtocol {
    func fetchData() async throws -> Data
    func decodeData<T: Decodable>(from data: Data, responseType: T.Type) throws -> T
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    static private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    private init() {}
    
    func fetchData() async throws -> Data {
        guard let url = URL(string: NetworkManager.urlString) else {
            throw NetworkError.invalidURL
        }
        
        if let (data, _) = try? await URLSession.shared.data(from: url) {
            return data
        }
        
        throw NetworkError.noData
    }
    
    func decodeData<T: Decodable>(from data: Data, responseType: T.Type) throws -> T {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
}

// Define custom errors for networking
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

// Recipe model that matches the JSON structure
struct Recipe: Decodable, Identifiable {
    let id = UUID()
    let cuisine: String
    let name: String
    let photoUrlLarge: String
    let photoUrlSmall: String
    let sourceUrl: String?
    let uuid: String
    let youtubeUrl: String?
    
    // Custom keys to map JSON fields to Swift property names
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case uuid
        case youtubeUrl = "youtube_url"
    }
}

// Root structure for the response
struct RecipeList: Decodable {
    let recipes: [Recipe]
}
