//
//  CategoryCell.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    
    func config() {
        categoryButton.layer.cornerRadius = categoryButton.frame.height / 2
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.borderColor = UserPreferences.buttonColor.cgColor
        categoryButton.backgroundColor = UserPreferences.mainBackgroundColor
        categoryButton.titleLabel?.tintColor = UserPreferences.buttonColor
    }
}
