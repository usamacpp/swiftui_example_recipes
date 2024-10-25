//
//  Recipe.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/23/24.
//

import Foundation

// Recipe model that matches the JSON structure
struct Recipe: Decodable, Identifiable {
    var id: UUID {
        UUID(uuidString: uuid) ?? UUID()
    }
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
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
