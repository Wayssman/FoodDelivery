//
//  FoodListLocalDataManager.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 18.05.2021.
//

import CoreData

// MARK: - CoreDataError
enum CoreDataError: Error {
  case managedObjectContextNotFound
  case couldNotSaveObject
  case objectNotFound
  case couldNotDeleteObjects
}

final class FoodListLocalDataManager: FoodListLocalDataManagerInputProtocol {
  // MARK: - Public Methods
  func getMeals() throws -> [MealModel] {
    guard let context = CoreDataStack.managedObjectContext else {
      throw CoreDataError.managedObjectContextNotFound
    }
    let request: NSFetchRequest<MealModel> = NSFetchRequest(entityName: String(describing: MealModel.self))
    request.returnsObjectsAsFaults = false
    
    return try context.fetch(request)
  }
  
  func clearMeals() throws {
    guard let context = CoreDataStack.managedObjectContext else {
      throw CoreDataError.managedObjectContextNotFound
    }
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: MealModel.self))
    let delete = NSBatchDeleteRequest(fetchRequest: request)
    
    do {
      try context.execute(delete)
    } catch {
      throw CoreDataError.couldNotDeleteObjects
    }
  }
  
  func saveMeal(networkMeal: MealModel) throws {
    guard let context = CoreDataStack.managedObjectContext else {
      throw CoreDataError.managedObjectContextNotFound
    }
    if let meal = NSEntityDescription.entity(forEntityName: "MealModel", in: context) {
      let newMeal = MealModel(entity: meal, insertInto: context)
      newMeal.name = networkMeal.name
      newMeal.category = networkMeal.category
      newMeal.preview = networkMeal.preview
      newMeal.ingredient1 = networkMeal.ingredient1
      newMeal.ingredient2 = networkMeal.ingredient2
      newMeal.ingredient3 = networkMeal.ingredient3
      newMeal.ingredient4 = networkMeal.ingredient4
      newMeal.ingredient5 = networkMeal.ingredient5
      newMeal.ingredient6 = networkMeal.ingredient6
      newMeal.ingredient7 = networkMeal.ingredient7
      newMeal.ingredient8 = networkMeal.ingredient8
      newMeal.ingredient9 = networkMeal.ingredient9
      newMeal.ingredient10 = networkMeal.ingredient10
      newMeal.ingredient11 = networkMeal.ingredient11
      newMeal.ingredient12 = networkMeal.ingredient12
      newMeal.ingredient13 = networkMeal.ingredient13
      newMeal.ingredient14 = networkMeal.ingredient14
      newMeal.ingredient15 = networkMeal.ingredient15
      newMeal.ingredient16 = networkMeal.ingredient16
      newMeal.ingredient17 = networkMeal.ingredient17
      newMeal.ingredient18 = networkMeal.ingredient18
      newMeal.ingredient19 = networkMeal.ingredient19
      newMeal.ingredient20 = networkMeal.ingredient20
      newMeal.recipe = networkMeal.recipe
      
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

