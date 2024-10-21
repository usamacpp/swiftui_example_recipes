//
//  ContentView.swift
//  RecipeApp
//
//  Created by ossama mikhail on 10/16/24.
//

import SwiftUI

class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []  // Exposed to the View
    @Published var errorMessage: String? = nil  // To handle errors
    
    @MainActor
    func fetchRecipes() async {
        do {
            let data = try await NetworkManager.shared.fetchData()
            let recipeList = try NetworkManager.shared.decodeData(from: data, responseType: RecipeList.self)
            recipes = recipeList.recipes
        } catch {
            errorMessage = "Failed to fetch recipes: \(error.localizedDescription)"
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = RecipesViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.recipes) { recipe in
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .font(.headline)
                    Text(recipe.cuisine)
                        .font(.subheadline)
                    if let url = URL(string: recipe.photoUrlSmall) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchRecipes()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(viewModel.errorMessage ?? "")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
