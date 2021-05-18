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

}

extension MealModel : Identifiable {

}
