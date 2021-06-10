//
//  FoodView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

final class FoodView: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Private Properties
  private var foodList: [MealObject] = []
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
  }
  
  // MARK: - Public Methods
  func setFoodList(list: [MealObject]) {
    self.foodList = list
  }
  
  func getMeal(at index: Int) -> MealObject {
    return foodList[index]
  }
  
  func processActiveCategory(name: String) {
    let mealIndex = foodList.firstIndex(where: { $0.category == name })
    guard let mealIndex = mealIndex else { return }
    tableView.scrollToRow(at: IndexPath(row: mealIndex, section: 0), at: .top, animated: true)
  }
  
  func getMealsCount() -> Int {
    return foodList.count
  }
}

// MARK: - UITableViewDataSource
extension FoodView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return foodList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
    cell.config(meal: foodList[indexPath.row])
    
    return cell
  }
}
