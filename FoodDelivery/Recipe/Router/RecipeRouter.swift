//
//  RecipeRouter.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 30.05.2021.
//

import UIKit

final class RecipeRouter: RecipeRouterProtocol {
  // MARK: - Static Methods
  static func createRecipeModule(forMeal: MealObject) -> UIViewController {
    let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "RecipeViewController")
    
    if let view = viewController as? RecipeView {
      let router: RecipeRouterProtocol = RecipeRouter()
      let presenter: RecipePresenterProtocol = RecipePresenter()
      
      view.presenter = presenter
      presenter.view = view
      presenter.router = router
      presenter.meal = forMeal
      
      return viewController
    }
    
    return UIViewController()
  }
  
  // MARK: - Public Methods
  func dismissRecipeScreen(from view: RecipeViewProtocol) {
    if let sourceView = view as? UIViewController {
      sourceView.navigationController?.popToRootViewController(animated: true)
    }
  }
}
