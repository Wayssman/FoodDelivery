//
//  RecipeProtocols.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 28.05.2021.
//

import UIKit

protocol RecipeRouterProtocol: AnyObject {
    static func createRecipeModule(forMeal: MealModelShowed) -> UIViewController
    
    // Запрос от Presenter к Router
    func dismissRecipeScreen(from view: RecipeViewProtocol)
}

protocol RecipeViewProtocol: AnyObject {
    var presenter: RecipePresenterProtocol? { get set }
    
    // Запрос от Presenter к View
    func showRecipe(forMeal: MealModelShowed)
}

protocol RecipePresenterProtocol: AnyObject {
    var view: RecipeViewProtocol? { get set }
    var router: RecipeRouterProtocol? { get set }
    var meal: MealModelShowed? { get set }
    
    // Запрос от View к Presenter
    func viewDidLoad()
    func dismissRecipe()
}

