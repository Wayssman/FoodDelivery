//
//  FoodListPresenter.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

final class FoodListPresenter: FoodListPresenterProtocol {
  // MARK: - Public Properties
  weak var view: FoodListViewProtocol?
  var router: FooldListRouterProtocol?
  var interactor: FoodListInteractorInputProtocol?
  
  // MARK: - Lifecycle
  func viewDidLoad() {
    view?.showLoading()
    interactor?.getFoodList()
  }
  
  // MARK: - Public Methods
  func showRecipe(forMeal meal: MealObject) {
    router?.presentRecipeScreen(from: view!, forMeal: meal)
  }
}

// MARK: - FoodListInteractorOutputProtocol
extension FoodListPresenter: FoodListInteractorOutputProtocol {
  func didRecieveFood(_ meals: [MealObject]) {
    view?.hideLoading()
    // Сортируем блюда по категориям и передаем
    view?.showFood(meals: meals.sorted(by: { lhs, rhs in
      lhs.category < rhs.category
    }))
  }
  
  func onError() {
    view?.hideLoading()
    view?.showError()
  }
}
