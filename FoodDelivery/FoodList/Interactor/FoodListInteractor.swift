//
//  FoodListInteractor.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

class FoodListInteractor: FoodListInteractorInputProtocol {
    
    weak var presenter: FoodListInteractorOutputProtocol?
    var remoteDataManager: FoodListRemoteDataManagerInputProtocol?
    var localDataManager: FoodListLocalDataManagerInputProtocol?
    
    func getFoodList() {
        remoteDataManager?.getFoodList()
        do {
            if let meals = try localDataManager?.getMeal() {
                if meals.isEmpty {
                    remoteDataManager?.getFoodList()
                } else {
                    presenter?.didRecieveFood(meals)
                }
            } else {
                remoteDataManager?.getFoodList()
            }
        } catch {
            presenter?.didRecieveFood([])
        }
    }
}

extension FoodListInteractor: FoodListRemoteDataManagerOutputProtocol {
    
    func onFoodReceived(_ meals: [MealModel]) {
        presenter?.didRecieveFood(meals)
        
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
        presenter?.onError()
    }
}
