//
//  MealService.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//
import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case noMealsFound
}

struct MealService {
    func fetchRandomMeal() async throws -> Meal {
        let endpoint = "https://www.themealdb.com/api/json/v1/1/random.php"
        
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let mealResponse = try decoder.decode(MealResponse.self, from: data)

            guard let meal = mealResponse.meals.first else {
                throw NetworkError.noMealsFound
            }
            
            return meal
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchRandomMeals(count: Int) async throws -> [Meal] {
        var meals: [Meal] = []
        
        try await withThrowingTaskGroup(of: Meal?.self) { group in
            for _ in 0..<count {
                group.addTask {
                    do {
                        return try await self.fetchRandomMeal()
                    } catch {
                        return nil
                    }
                }
            }
            
            for try await meal in group {
                if let meal = meal {
                    meals.append(meal)
                }
            }
        }
        
        return meals
    }
}
