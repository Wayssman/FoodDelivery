//
//  MealModel.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

import Foundation
import ObjectMapper

struct MealResponse {
    var meals: [MealModel]?
}

struct MealModel {
    var name: String = ""
    var category: String = ""
    var preview: String = ""
    var ingredient1: String?
    var ingredient2: String?
    var ingredient3: String?
    var ingredient4: String?
    var ingredient5: String?
}

extension MealModel: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        name <- map["strMeal"]
        category <- map["strCategory"]
        preview <- map["strMealThumb"]
        ingredient1 <- map["strIngredient1"]
        ingredient2 <- map["strIngredient2"]
        ingredient3 <- map["strIngredient3"]
        ingredient4 <- map["strIngredient4"]
        ingredient5 <- map["strIngredient5"]
    }
}

extension MealResponse: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        meals <- map["meals"]
    }
}
