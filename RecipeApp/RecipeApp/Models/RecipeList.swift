//
//  RecipeList.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/23/24.
//

// Root structure for the response
struct RecipeList: Decodable {
    let recipes: [Recipe]
}
