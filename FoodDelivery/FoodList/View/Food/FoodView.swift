//
//  FoodView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class FoodView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var foodList: [MealModelShowed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func processActiveCategory(name: String) {
        let mealIndex = foodList.firstIndex(where: { $0.category == name })
        guard let meal = mealIndex else { return }
        tableView.scrollToRow(at: IndexPath(row: meal, section: 0), at: .top, animated: true)
    }
}

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
