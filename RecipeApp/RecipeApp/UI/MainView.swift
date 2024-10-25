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
            let data = try await NetworkManager.shared.fetchRecipeList()
            let recipeList = try NetworkManager.shared.decodeData(
                from: data, responseType: RecipeList.self)
            recipes = recipeList.recipes
        } catch {
            errorMessage =
                "Failed to fetch recipes: \(error.localizedDescription)"
        }
    }

    @MainActor
    func refreshRecipes() async {
        recipes = []
        errorMessage = nil
        await fetchRecipes()
    }
}

struct MainView: View {
    @StateObject private var viewModel = RecipesViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.recipes) { recipe in
                RecipeCell(recipe: recipe)
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchRecipes()
            }
            .alert(
                "Error",
                isPresented: .constant(viewModel.errorMessage != nil),
                actions: {
                    Button("OK", role: .cancel) {}
                },
                message: {
                    Text(viewModel.errorMessage ?? "error details unavailable")
                })
        }.refreshable {
            Task {
                print("refreshing...")
                await viewModel.refreshRecipes()
            }
        }
    }
}

#Preview {
    MainView()
}
