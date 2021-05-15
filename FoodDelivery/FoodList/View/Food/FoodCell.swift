//
//  FoodCell.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class FoodCell: UITableViewCell {
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = UserPreferences.textColor
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = UserPreferences.descriptionTextColor
        priceButton.layer.borderWidth = 1
        priceButton.layer.borderColor = UserPreferences.selectedButtonTextColor.cgColor
        priceButton.titleLabel?.tintColor = UserPreferences.selectedButtonTextColor
        priceButton.layer.cornerRadius = 6
        priceButton.backgroundColor = .white
    }
}
