//
//  FoodListRouter.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

final class FoodListRouter: FooldListRouterProtocol {
  // MARK: - Static Methods
  class func createFoodListModule() -> UIViewController {
    let navigationController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "FoodNavigationController")
    
    if let view = navigationController.children.first as? FoodListView {
      let router: FoodListRouter = FoodListRouter()
      let presenter: FoodListPresenterProtocol & FoodListInteractorOutputProtocol = FoodListPresenter()
      let interactor: FoodListInteractorInputProtocol & FoodListRemoteDataManagerOutputProtocol = FoodListInteractor()
      let remoteDataManager: FoodListRemoteDataManagerInputProtocol = FoodListRemoteDataManager()
      let localDataManager: FoodListLocalDataManagerInputProtocol = FoodListLocalDataManager()
      
      view.presenter = presenter
      presenter.view = view
      presenter.router = router
      presenter.interactor = interactor
      interactor.presenter = presenter
      interactor.remoteDataManager = remoteDataManager
      interactor.localDataManager = localDataManager
      remoteDataManager.remoteRequestHandler = interactor
      
      return navigationController
    }
    
    return UIViewController()
  }
  
  // MARK: - Public Methods
  func presentRecipeScreen(from view: FoodListViewProtocol, forMeal meal: MealObject) {
    let recipeViewController = RecipeRouter.createRecipeModule(forMeal: meal)
    
    if let sourceView = view as? UIViewController {
      sourceView.navigationController?.pushViewController(recipeViewController, animated: true)
    }
  }
}
