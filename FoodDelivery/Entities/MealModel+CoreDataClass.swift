//
//  MealModel+CoreDataClass.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 18.05.2021.
//
//

import Foundation
import CoreData

struct MealResponse: Decodable {
    var meals: [MealModel]?
}

public class MealModel: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case category = "strCategory"
        case preview = "strMealThumb"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"
        case recipe = "strInstructions"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
        let entity = NSEntityDescription.entity(forEntityName: "MealModel", in: context)!
        self.init(entity: entity, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        category = try values.decode(String.self, forKey: .category)
        preview = try values.decode(String.self, forKey: .preview)
        ingredient1 = try values.decode(String.self, forKey: .ingredient1)
        ingredient2 = try values.decode(String.self, forKey: .ingredient2)
        ingredient3 = try values.decode(String.self, forKey: .ingredient3)
        ingredient4 = try values.decode(String.self, forKey: .ingredient4)
        ingredient5 = try values.decode(String.self, forKey: .ingredient5)
        ingredient6 = try values.decode(String.self, forKey: .ingredient6)
        ingredient7 = try values.decode(String.self, forKey: .ingredient7)
        ingredient8 = try values.decode(String.self, forKey: .ingredient8)
        ingredient9 = try values.decode(String.self, forKey: .ingredient9)
        ingredient10 = try values.decode(String.self, forKey: .ingredient10)
        ingredient11 = try values.decode(String.self, forKey: .ingredient11)
        ingredient12 = try values.decode(String.self, forKey: .ingredient12)
        ingredient13 = try values.decode(String.self, forKey: .ingredient13)
        ingredient14 = try values.decode(String.self, forKey: .ingredient14)
        ingredient15 = try values.decode(String.self, forKey: .ingredient15)
        ingredient16 = try values.decode(String.self, forKey: .ingredient16)
        ingredient17 = try values.decode(String.self, forKey: .ingredient17)
        ingredient18 = try values.decode(String.self, forKey: .ingredient18)
        ingredient19 = try values.decode(String.self, forKey: .ingredient19)
        ingredient20 = try values.decode(String.self, forKey: .ingredient20)
        recipe = try values.decode(String.self, forKey: .recipe)
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
    
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}
