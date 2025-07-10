//
//  Meal.swift
//  RecipeApp
//
//  Created by Dylan Young on 7/9/25.
//
//

import Foundation

struct MealResponse: Codable {
    let meals: [Meal]
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
    let measure: String
    
    var displayText: String {
        return "\(measure) \(name)"
    }
}

struct Meal: Codable, Identifiable {
    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnail: String?
    let tags: String?
    let youtube: String?
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case area = "strArea"
        case instructions = "strInstructions"
        case thumbnail = "strMealThumb"
        case tags = "strTags"
        case youtube = "strYoutube"
        
        // Ingredient keys
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10
        case strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15
        case strIngredient16, strIngredient17, strIngredient18, strIngredient19, strMeasure20
        
        // Measure keys
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
        case strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10
        case strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15
        case strMeasure16, strMeasure17, strMeasure18, strMeasure19, strIngredient20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        area = try container.decodeIfPresent(String.self, forKey: .area)
        instructions = try container.decodeIfPresent(String.self, forKey: .instructions)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        tags = try container.decodeIfPresent(String.self, forKey: .tags)
        youtube = try container.decodeIfPresent(String.self, forKey: .youtube)
        
        // Parse ingredients and measures
        var ingredients: [Ingredient] = []
        
        let ingredientKeys: [CodingKeys] = [
            .strIngredient1, .strIngredient2, .strIngredient3, .strIngredient4, .strIngredient5,
            .strIngredient6, .strIngredient7, .strIngredient8, .strIngredient9, .strIngredient10,
            .strIngredient11, .strIngredient12, .strIngredient13, .strIngredient14, .strIngredient15,
            .strIngredient16, .strIngredient17, .strIngredient18, .strIngredient19, .strIngredient20
        ]
        
        let measureKeys: [CodingKeys] = [
            .strMeasure1, .strMeasure2, .strMeasure3, .strMeasure4, .strMeasure5,
            .strMeasure6, .strMeasure7, .strMeasure8, .strMeasure9, .strMeasure10,
            .strMeasure11, .strMeasure12, .strMeasure13, .strMeasure14, .strMeasure15,
            .strMeasure16, .strMeasure17, .strMeasure18, .strMeasure19, .strMeasure20
        ]
        
        for i in 0..<ingredientKeys.count {
            let ingredientName = try container.decodeIfPresent(String.self, forKey: ingredientKeys[i])
            let measure = try container.decodeIfPresent(String.self, forKey: measureKeys[i])
            
            if let ingredientName = ingredientName,
               !ingredientName.isEmpty,
               let measure = measure,
               !measure.isEmpty {
                ingredients.append(Ingredient(name: ingredientName, measure: measure))
            }
        }
        
        self.ingredients = ingredients
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(area, forKey: .area)
        try container.encodeIfPresent(instructions, forKey: .instructions)
        try container.encodeIfPresent(thumbnail, forKey: .thumbnail)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(youtube, forKey: .youtube)
        
        // Note: Encoding ingredients back to the flat structure would be complex
        // For most use cases, you'll only need to decode from the API
    }
}
