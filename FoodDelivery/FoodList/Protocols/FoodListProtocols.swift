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
}

protocol FoodListPresenterProtocol: class {
    var view: FoodListViewProtocol? { get set }
    var router: FooldListRouterProtocol? { get set }
    
    func viewDidLoad()
}
