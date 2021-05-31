//
//  MealModel+CoreDataProperties.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 18.05.2021.
//
//

import Foundation
import CoreData


extension MealModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealModel> {
        return NSFetchRequest<MealModel>(entityName: "MealModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var preview: String?
    @NSManaged public var ingredient1: String?
    @NSManaged public var ingredient2: String?
    @NSManaged public var ingredient3: String?
    @NSManaged public var ingredient4: String?
    @NSManaged public var ingredient5: String?
    @NSManaged public var ingredient6: String?
    @NSManaged public var ingredient7: String?
    @NSManaged public var ingredient8: String?
    @NSManaged public var ingredient9: String?
    @NSManaged public var ingredient10: String?
    @NSManaged public var ingredient11: String?
    @NSManaged public var ingredient12: String?
    @NSManaged public var ingredient13: String?
    @NSManaged public var ingredient14: String?
    @NSManaged public var ingredient15: String?
    @NSManaged public var ingredient16: String?
    @NSManaged public var ingredient17: String?
    @NSManaged public var ingredient18: String?
    @NSManaged public var ingredient19: String?
    @NSManaged public var ingredient20: String?
    @NSManaged public var recipe: String?
}

extension MealModel : Identifiable {

}
