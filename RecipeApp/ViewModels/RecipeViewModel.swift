//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//

import SwiftUI
import Combine

@MainActor
final class RecipeViewModel: ObservableObject {
    @Published private var recipeList: [Meal] = []
    @Published var isLoading: Bool = true
    
    var currentMeal: Meal? {
        recipeList.first
    }
    
    // Add computed property for next meal
    var nextMeal: Meal? {
        recipeList.count > 1 ? recipeList[1] : nil
    }
    
    func fetchRandomMeals() async {
        do {
            let meals = try await MealService().fetchRandomMeals(count: 10)
            self.recipeList = meals
            self.isLoading = false

        } catch {
            self.isLoading = false
            print("Failed to fetch random meals: \(error)")
        }
    }
    
    func loadNextMeal() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if !recipeList.isEmpty {
                recipeList.removeFirst()
                
                // If we're running low on meals, fetch more
                if recipeList.count <= 2 {
                    Task {
                        await fetchMoreMeals()
                    }
                }
            }
        }
    }
    
    private func fetchMoreMeals() async {
        do {
            let newMeals = try await MealService().fetchRandomMeals(count: 10)
            self.recipeList.append(contentsOf: newMeals)
        } catch {
            print("Failed to fetch more meals: \(error)")
        }
    }
}
