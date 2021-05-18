//
//  FoodListRemoteDataManager.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

import Foundation
import Alamofire

class FoodListRemoteDataManager: FoodListRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: FoodListRemoteDataManagerOutputProtocol?
    
    func getFoodList() {
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "http"
        urlConstructor.host = "www.themealdb.com"
        urlConstructor.path = "/api/json/v1/1/search.php"
        // Для примера грузим все блюда на букву 'c'
        urlConstructor.queryItems = [URLQueryItem(name: "f", value: "e")]
        
        Alamofire.request(urlConstructor.url!)
            .validate()
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(MealResponse.self, from: data)
                        self.remoteRequestHandler?.onFoodReceived(result.meals ?? [])
                    } catch {
                        // Можно распарсить ошибку декодинга
                        self.remoteRequestHandler?.onError()
                    }
                case .failure(_):
                    // Можно распарсить ошибку сети
                    self.remoteRequestHandler?.onError()
                }
            })
    }
}


