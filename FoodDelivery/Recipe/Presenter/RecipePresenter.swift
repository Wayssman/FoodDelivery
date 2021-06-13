//
//  RecipePresenter.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 30.05.2021.
//

import Foundation

final class RecipePresenter: RecipePresenterProtocol {
  // MARK: - Public Properties
  weak var view: RecipeViewProtocol?
  var router: RecipeRouterProtocol?
  var meal: MealObject?
  
  // MARK: - Lifecycle
  func viewDidLoad() {
    view?.showRecipe(forMeal: meal!)
  }
  
  // MARK: - Public Methods
  @objc func dismissRecipe() {
    router?.dismissRecipeScreen(from: view!)
  }
}
