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
}
