//
//  CacheManager.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/23/24.
//

import UIKit

protocol CacheManagerProtocol {
    func addImage(url: String, image: UIImage) async
    func isImageExisting(forUrl: String) async -> UIImage?
    func freeCache() async
}

actor CacheManager: CacheManagerProtocol {
    static let shared = CacheManager()
    private var cache = [String: (UIImage, Date)]()
    
    func addImage(url: String, image: UIImage) async {
        await freeCache()
        cache[url] = (image, Date())
    }
    
    func isImageExisting(forUrl: String) async -> UIImage? {
        return cache[forUrl]?.0
    }
    
    func freeCache() async {
        if cache.count > 100 {
            cache = [String: (UIImage, Date)]()
        }
    }
}
