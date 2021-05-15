//
//  FoodListRouter.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class FoodListRouter: FooldListRouterProtocol {
    
    class func createFoodListModule() -> UIViewController {
        let navigationController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "FoodNavigationController")
        
        if let view = navigationController.children.first as? FoodListView {
            let presenter: FoodListPresenterProtocol = FoodListPresenter()
            let router: FoodListRouter = FoodListRouter()
            
            view.presenter = presenter
            presenter.view = view
            presenter.router = router
            
            return navigationController
        }
        
        return UIViewController()
    }
}
