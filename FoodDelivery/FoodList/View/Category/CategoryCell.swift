//
//  CategoryCell.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    
    func config(category: String, selected: Bool) {
        categoryButton.layer.cornerRadius = categoryButton.frame.height / 2
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UserPreferences.buttonColor.cgColor
        categoryButton.setTitle(category, for: .normal)
        
        if selected {
            categoryButton.backgroundColor = UserPreferences.selectedButtonColor
            categoryButton.titleLabel?.tintColor = UserPreferences.selectedButtonTextColor
            categoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        } else {
            categoryButton.backgroundColor = UserPreferences.mainBackgroundColor
            categoryButton.titleLabel?.tintColor = UserPreferences.buttonColor
            categoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
    }
}
