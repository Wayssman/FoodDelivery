//
//  FoodListLocalDataManager.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 18.05.2021.
//

import CoreData

enum CoreDataError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case objectNotFound
}

class FoodListLocalDataManager: FoodListLocalDataManagerInputProtocol {
    
    func getMeal() throws -> [MealModel] {
        guard let context = CoreDataStack.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        let request: NSFetchRequest<MealModel> = NSFetchRequest(entityName: String(describing: MealModel.self))
        
        return try context.fetch(request)
    }
    
    func saveMeal(networkMeal: MealModel) throws {
        guard let context = CoreDataStack.managedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        if let newMeal = NSEntityDescription.entity(forEntityName: "MealModel", in: context) {
            let meal = MealModel(entity: newMeal, insertInto: context)
            meal.name = networkMeal.name
            meal.category = networkMeal.category
            meal.preview = networkMeal.preview
            meal.ingredient1 = networkMeal.ingredient1
            meal.ingredient2 = networkMeal.ingredient2
            meal.ingredient3 = networkMeal.ingredient3
            meal.ingredient4 = networkMeal.ingredient4
            meal.ingredient5 = networkMeal.ingredient5
            
            do {
                try context.save()
            } catch {
                // Выбрасываем свою ошибку
                throw CoreDataError.couldNotSaveObject
            }
        } else {
            throw CoreDataError.objectNotFound
        }
    }
}
