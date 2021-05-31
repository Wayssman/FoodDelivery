//
//  FoodCell.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit
import AlamofireImage

class FoodCell: UITableViewCell {
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = UserPreferences.textColor
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = UserPreferences.descriptionTextColor
        descriptionLabel.numberOfLines = 0
        
        priceButton.layer.borderWidth = 1
        priceButton.layer.borderColor = UserPreferences.selectedButtonTextColor.cgColor
        priceButton.titleLabel?.tintColor = UserPreferences.selectedButtonTextColor
        priceButton.layer.cornerRadius = 6
        priceButton.backgroundColor = .white
        
        preview.layer.cornerRadius = 10
    }
    
    func config(meal: MealModelShowed) {
        titleLabel.text = meal.name
        
        descriptionLabel.text = meal.ingredients.compactMap{$0}.filter{ $0.count > 0 }.enumerated().filter { $0.offset < 5 }.map{ $0.element }.joined(separator: ", ")
        
        priceButton.setTitle("от 345 р", for: .normal)
        
        let url = URL(string: meal.preview)!
        let placeholder = UIImage(named: "placeholder")
        preview?.af.setImage(withURL: url, placeholderImage: placeholder)
    }
}
