//
//  FoodListPresenter.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

class FoodListPresenter: FoodListPresenterProtocol {
    
    weak var view: FoodListViewProtocol?
    var router: FooldListRouterProtocol?
    var interactor: FoodListInteractorInputProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getFoodList()
    }
    
    func showRecipe(forMeal meal: MealModelShowed) {
        router?.presentRecipeScreen(from: view!, forMeal: meal)
    }
}

extension FoodListPresenter: FoodListInteractorOutputProtocol {
    
    func didRecieveFood(_ meals: [MealModel]) {
        view?.hideLoading()
        
        // View не надо знать о той модели, которая приходит на вход
        var mealsShowed: [MealModelShowed] = []
        // Создаем модель для View
        _ = meals.map{ mealsShowed.append(MealModelShowed(name: $0.name ?? "", category: $0.category ?? "", preview: $0.preview ?? "", recipe: $0.recipe ?? "" ,ingredients: [$0.ingredient1, $0.ingredient2, $0.ingredient3, $0.ingredient4, $0.ingredient5, $0.ingredient6, $0.ingredient7, $0.ingredient8, $0.ingredient9, $0.ingredient10, $0.ingredient11, $0.ingredient12, $0.ingredient13, $0.ingredient14, $0.ingredient15, $0.ingredient16, $0.ingredient17, $0.ingredient18, $0.ingredient19, $0.ingredient20])) }
        // Сортируем блюда по категориям и передаем
        view?.showFood(meals: mealsShowed.sorted(by: { lhs, rhs in
            lhs.category < rhs.category
        }))
    }
    
    func onError() {
        view?.hideLoading()
        view?.showError()
    }
}
