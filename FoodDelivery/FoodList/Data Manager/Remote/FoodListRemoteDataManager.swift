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
        
        let decoder = JSONDecoder(context: CoreDataStack.managedObjectContext!)
        
        AF.request(urlConstructor.url!)
            .validate()
            .responseDecodable(of: MealResponse.self, decoder: decoder) { response in
                switch response.result {
                case .success(let result):
                    self.remoteRequestHandler?.onFoodReceived(result.meals ?? [])
                case .failure(_):
                    self.remoteRequestHandler?.onError()
                }
            }
    }
}


