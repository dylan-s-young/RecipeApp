//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//

import SwiftUI
import Combine

final class RecipeViewModel: ObservableObject {
    @Published private var recipeList: [Meal] = []
    @Published var isLoading: Bool = true
    
    var currentMeal: Meal? {
        recipeList.first
    }
    
    func fetchRandomMeals() async {
        isLoading = true
        do {
            let meals = try await MealService().fetchRandomMeals(count: 10)
            DispatchQueue.main.async {
                self.recipeList = meals
                self.isLoading = false
            }
            // Future: Add logic to automatically fetch more meals when user scrolls near index 5
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            print("Failed to fetch random meals: \(error)")
        }
    }
    
    
    
}
