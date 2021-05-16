//
//  FoodListProtocols.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

protocol FooldListRouterProtocol: class {
    static func createFoodListModule() -> UIViewController
}

protocol FoodListViewProtocol: class {
    var presenter: FoodListPresenterProtocol? { get set }
    
    // Запрос от Presenter к View
    func showFood(meals: [MealModelShowed])
    
    func showError()
    func showLoading()
    func hideLoading()
}

protocol FoodListPresenterProtocol: class {
    var router: FooldListRouterProtocol? { get set }
    var view: FoodListViewProtocol? { get set }
    var interactor: FoodListInteractorInputProtocol? { get set }
    
    // Уведомление от View к Presenter
    func viewDidLoad()
}

protocol FoodListInteractorInputProtocol: class {
    var presenter: FoodListInteractorOutputProtocol? { get set }
    var remoteDataManager: FoodListRemoteDataManagerInputProtocol? { get set }
    
    // Запрос от Presenter к Interactor
    func getFoodList()
}

protocol FoodListInteractorOutputProtocol: class {
    // Ответ от Interactor к Presenter
    func didRecieveFood(_ meals: [MealModel])
    func onError()
}

protocol FoodListRemoteDataManagerInputProtocol: class {
    var remoteRequestHandler: FoodListRemoteDataManagerOutputProtocol? { get set }
    
    // Запрос от Interactor к DataManager
    func getFoodList()
}

protocol FoodListRemoteDataManagerOutputProtocol: class {
    // Ответ от DataManager к Interactor
    func onFoodReceived(_ meals: [MealModel])
    func onError()
}
