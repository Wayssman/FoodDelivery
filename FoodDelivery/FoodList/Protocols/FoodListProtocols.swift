//
//  FoodListProtocols.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

protocol FooldListRouterProtocol: AnyObject {
  static func createFoodListModule() -> UIViewController
  
  // Запрос от Presenter к Router
  func presentRecipeScreen(from view: FoodListViewProtocol, forMeal meal: MealObject)
}

protocol FoodListViewProtocol: AnyObject {
  var presenter: FoodListPresenterProtocol? { get set }
  
  // Запрос от Presenter к View
  func showFood(meals: [MealObject])
  
  func showError()
  func showLoading()
  func hideLoading()
}

protocol FoodListPresenterProtocol: AnyObject {
  var router: FooldListRouterProtocol? { get set }
  var view: FoodListViewProtocol? { get set }
  var interactor: FoodListInteractorInputProtocol? { get set }
  
  // Уведомление от View к Presenter
  func viewDidLoad()
  func showRecipe(forMeal meal: MealObject)
}

protocol FoodListInteractorInputProtocol: AnyObject {
  var presenter: FoodListInteractorOutputProtocol? { get set }
  var remoteDataManager: FoodListRemoteDataManagerInputProtocol? { get set }
  var localDataManager: FoodListLocalDataManagerInputProtocol? { get set }
  
  // Запрос от Presenter к Interactor
  func getFoodList()
}

protocol FoodListInteractorOutputProtocol: AnyObject {
  // Ответ от Interactor к Presenter
  func didRecieveFood(_ meals: [MealObject])
  func onError()
}

protocol FoodListRemoteDataManagerInputProtocol: AnyObject {
  var remoteRequestHandler: FoodListRemoteDataManagerOutputProtocol? { get set }
  
  // Запрос от Interactor к DataManager
  func getFoodList()
}

protocol FoodListRemoteDataManagerOutputProtocol: AnyObject {
  // Ответ от DataManager к Interactor
  func onFoodReceived(_ meals: [MealModel])
  func onError()
}

protocol FoodListLocalDataManagerInputProtocol: AnyObject {
  // Запрос от Interactor к LocalDataManager
  func getMeals() throws -> [MealModel]
  func saveMeal(networkMeal: MealModel) throws
  func clearMeals() throws
}
