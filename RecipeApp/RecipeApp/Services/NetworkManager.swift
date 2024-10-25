//
//  NetworkManager.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/19/24.
//


import UIKit

// Define custom errors for networking
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol NetworkManagerProtocol {
    func fetchRecipeList() async throws -> Data
    func downloadPhoto(from url: String) async throws -> UIImage
    func downloadPhotos(from urls: [String]) async -> [String: UIImage]
}

struct NetworkManager: NetworkManagerProtocol, RecipeDecoder {
    static let shared = NetworkManager()
    static private let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    private init() {}
    
    func fetchRecipeList() async throws -> Data {
        URLCache.shared.removeAllCachedResponses()
        URLSession.shared.configuration.urlCache = nil
        
        guard let url = URL(string: NetworkManager.urlString) else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        
        if let (data, _) = try? await URLSession.shared.data(for: request) {
            return data
        }
        
        throw NetworkError.noData
    }
    
    func downloadPhoto(from surl: String) async throws -> UIImage {
        guard let url = URL(string: surl) else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        
        if let (data, _) = try? await URLSession.shared.data(for: request) {
            if let img = UIImage(data: data) {
                return img
            }
            
            throw NetworkError.decodingError
        }
        
        throw NetworkError.noData
    }
    
    func downloadPhotos(from urls: [String]) async -> [String: UIImage] {
        let photos = await withTaskGroup(of: (Optional<UIImage>, String).self) { group in
            for url in urls {
                group.addTask {
                    let photo = try? await self.downloadPhoto(from: url)
                    return (photo, url)
                }
            }
            
            var resultsDictionary = [String: UIImage]()
            for await result in group {
                if let photo = result.0 {
                    resultsDictionary[result.1] = photo
                }
            }
            
            return resultsDictionary
        }
        
        return photos
    }
}
