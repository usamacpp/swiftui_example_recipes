//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/23/24.
//

import SwiftUI

struct RecipeCell: View {
    let recipe: Recipe
    @State private var smallPhoto: UIImage?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.headline)
            Text(recipe.cuisine)
                .font(.subheadline)
            if let smallPhoto {
                Image(uiImage: smallPhoto)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
            }
        }.task {
            print("loading: \(recipe.name)")
            
            if let photoUrl = recipe.photoUrlSmall {
                smallPhoto = try? await NetworkManager.shared.downloadPhoto(from: photoUrl)
            }
        }.onDisappear() {
            print("unloading: \(recipe.name)")
        }
    }
}

#Preview {
    let json = """
                        {
                            \"cuisine\": \"Malaysian\",
                            \"name\": \"Apam Balik\",
                            \"photo_url_large\": \"https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg\",
                            \"photo_url_small\":\"https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg\",
                            \"source_url\": \"https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ\",
                            \"uuid\": \"0c6ca6e7-e32a-4053-b824-1dbf749910d8\",
                            \"youtube_url\": \"https://www.youtube.com/watch?v=6R8ffRRJcrg\"
                        }
                    """.data(using: .utf8)!
    let recipe = try! NetworkManager.shared.decodeData(from: json, responseType: Recipe.self)
    
    RecipeCell(recipe: recipe)
}

#Preview("without photo") {
    let json = """
                        {
                            \"cuisine\": \"Malaysian\",
                            \"name\": \"Apam Balik\",
                            \"photo_url_large\": \"https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg\",
                            \"source_url\": \"https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ\",
                            \"uuid\": \"0c6ca6e7-e32a-4053-b824-1dbf749910d8\",
                            \"youtube_url\": \"https://www.youtube.com/watch?v=6R8ffRRJcrg\"
                        }
                    """.data(using: .utf8)!
    let recipe = try! NetworkManager.shared.decodeData(from: json, responseType: Recipe.self)
    
    RecipeCell(recipe: recipe)
}
