//
//  FoodListRemoteDataManager.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class FoodListRemoteDataManager: FoodListRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: FoodListRemoteDataManagerOutputProtocol?
    
    func getFoodList() {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "http"
        urlConstructor.host = "www.themealdb.com"
        urlConstructor.path = "/api/json/v1/1/search.php"
        // Для примера грузим все блюда на букву 'c'
        urlConstructor.queryItems = [URLQueryItem(name: "f", value: "d")]
        
        Alamofire
            .request(urlConstructor.url!)
            .validate()
            .responseObject(completionHandler: { (response: DataResponse<MealResponse>) in
                switch response.result {
                case .success(let response):
                    self.remoteRequestHandler?.onFoodReceived(response.meals ?? [])
                case .failure(_): // Отсюда можно распарсить и пробросить ошибки
                    self.remoteRequestHandler?.onError()
                }
            })
    }
}


