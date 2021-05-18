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
