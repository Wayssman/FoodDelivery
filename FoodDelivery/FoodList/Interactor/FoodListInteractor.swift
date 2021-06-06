//
//  FoodListInteractor.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

// MARK: - InteractorInputProtocol
final class FoodListInteractor: FoodListInteractorInputProtocol {
  // MARK: - Public Properties
  weak var presenter: FoodListInteractorOutputProtocol?
  var remoteDataManager: FoodListRemoteDataManagerInputProtocol?
  var localDataManager: FoodListLocalDataManagerInputProtocol?
  
  // MARK: - Public Methods
  func getFoodList() {
    // Сначала грузим доступную информацию из БД
    do {
      if let meals = try localDataManager?.getMeals() {
        if !meals.isEmpty {
          presenter?.didRecieveFood(generateMealObjects(from: meals))
        }
      }
    } catch {
      // Если не можем получить данные из БД, передаем пустую информация
      presenter?.didRecieveFood([])
    }
    // Затем, грузим информацию с сервера
    remoteDataManager?.getFoodList()
  }
  
  // MARK: - Private Methods
  private func generateMealObjects(from meals: [MealModel]) -> [MealObject] {
    // Создаем POSO. По сути - коннектер между данными БД и API с нужной для отображения структурой данных.
    var mealObjects = [MealObject]()
    for meal in meals {
      let ingredients = [meal.ingredient1, meal.ingredient2, meal.ingredient3, meal.ingredient4,
                         meal.ingredient5, meal.ingredient6, meal.ingredient7, meal.ingredient8,
                         meal.ingredient9, meal.ingredient10, meal.ingredient11, meal.ingredient12,
                         meal.ingredient13, meal.ingredient14, meal.ingredient15, meal.ingredient16,
                         meal.ingredient17, meal.ingredient18, meal.ingredient19, meal.ingredient20]
      mealObjects.append(MealObject(name: meal.name ?? "",
                                    category: meal.category ?? "",
                                    preview: meal.preview ?? "",
                                    recipe: meal.recipe ?? "",
                                    ingredients: ingredients))
    }
    
    return mealObjects
  }
}

// MARK: - RemoteDataManagerOutputProtocol
extension FoodListInteractor: FoodListRemoteDataManagerOutputProtocol {
  func onFoodReceived(_ meals: [MealModel]) {
    // Передаем полученные данные дальше
    presenter?.didRecieveFood(generateMealObjects(from: meals))
    
    // Затираем старые значение в БД
    do {
      try localDataManager?.clearMeals()
    } catch {
      // Можно распарсить ошибку удаление из БД
      print(error)
    }
    
    // Сохраняем новые значения
    for mealModel in meals {
      do {
        try localDataManager?.saveMeal(networkMeal: mealModel)
      } catch {
        // Можно распарсить ошибку сохранения в базу данных
        print(error)
      }
    }
  }
  
  func onError() {
    // Не удается загрузить данные с сервера
    presenter?.onError()
  }
}
