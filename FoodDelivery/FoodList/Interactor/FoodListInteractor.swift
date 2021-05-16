//
//  FoodListInteractor.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

class FoodListInteractor: FoodListInteractorInputProtocol {
    weak var presenter: FoodListInteractorOutputProtocol?
    var remoteDataManager: FoodListRemoteDataManagerInputProtocol?
    
    
    func getFoodList() {
        remoteDataManager?.getFoodList()
    }
}

extension FoodListInteractor: FoodListRemoteDataManagerOutputProtocol {
    func onFoodReceived(_ meals: [MealModel]) {
        presenter?.didRecieveFood(meals)
    }
    
    func onError() {
        presenter?.onError()
    }
}
