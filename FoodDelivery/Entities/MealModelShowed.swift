//
//  MealModelShowed.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 16.05.2021.
//

import Foundation

struct MealModelShowed {
    var name: String = ""
    var category: String = ""
    var preview: String = ""
    var recipe = ""
    var ingredients: [String?] = []
}

// Plain Old Swift Object, чтобы отвязаться от структуры БД и API. Данный объект завязан на нужных для View данных (Dependency Inversion), и с помощью него осуществляется передача данных между модулями.
struct MealObject {
  var name: String = ""
  var category: String = ""
  var preview: String = ""
  var recipe = ""
  var ingredients: [String?] = []
}
