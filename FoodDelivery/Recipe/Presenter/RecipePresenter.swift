//
//  RecipePresenter.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 30.05.2021.
//

import Foundation

class RecipePresenter: RecipePresenterProtocol {
    
    weak var view: RecipeViewProtocol?
    var router: RecipeRouterProtocol?
    var meal: MealModelShowed?
    
    func viewDidLoad() {
        view?.showRecipe(forMeal: meal!)
    }
    
    
    @objc func dismissRecipe() {
        router?.dismissRecipeScreen(from: view!)
    }
}
