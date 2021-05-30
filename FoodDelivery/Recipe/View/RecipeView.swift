//
//  ReceipView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 28.05.2021.
//

import UIKit

class RecipeView: UIViewController {
    
    var presenter: RecipePresenterProtocol?
    
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension RecipeView: RecipeViewProtocol {
    
    func showRecipe(forMeal: MealModelShowed) {
        print("show")
    }
}
