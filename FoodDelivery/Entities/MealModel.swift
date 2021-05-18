//
//  MealModel.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

import Foundation

struct MealResponse: Codable {
    var meals: [MealModel]?
}

struct MealModel: Codable {
    var name: String = ""
    var category: String = ""
    var preview: String = ""
    var ingredient1: String?
    var ingredient2: String?
    var ingredient3: String?
    var ingredient4: String?
    var ingredient5: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case category = "strCategory"
        case preview = "strMealThumb"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
    }
}
