//
//  ReceipView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 28.05.2021.
//

import UIKit
import AlamofireImage

class RecipeView: UIViewController {
    
    var presenter: RecipePresenterProtocol?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var previewContainer: UIView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var contentViewTop: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    
    private var animator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // Задаем стиль
        view.backgroundColor = UserPreferences.mainBackgroundColor
        scrollContentView.backgroundColor = UserPreferences.mainBackgroundColor
        
        // Тень и форма contentView
        let path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let cornerMaskLayer = CAShapeLayer()
        cornerMaskLayer.path = path.cgPath
        cornerMaskLayer.fillColor = UIColor.white.cgColor
        
        cornerMaskLayer.shadowColor = UserPreferences.shadowColor.cgColor
        cornerMaskLayer.shadowPath = cornerMaskLayer.path
        cornerMaskLayer.shadowOffset = CGSize(width: 0, height: 1)
        cornerMaskLayer.shadowOpacity = 1
        cornerMaskLayer.shadowRadius = 10
        
        contentView.layer.backgroundColor = .none
        contentView.layer.insertSublayer(cornerMaskLayer, at: 0)
        
        // Тень previewContainer
        previewContainer.backgroundColor = .none
        previewContainer.layer.shadowColor = UIColor.black.cgColor
        previewContainer.layer.shadowPath = UIBezierPath(ovalIn: previewContainer.bounds).cgPath
        previewContainer.layer.shadowOffset = .zero
        previewContainer.layer.shadowOpacity = 1
        previewContainer.layer.shadowRadius = 5
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(_:)))
        preview.addGestureRecognizer(tapGestureRecognizer)
        preview.addGestureRecognizer(longPressGestureRecognizer)
        preview.isUserInteractionEnabled = true
        
        // Форма preview
        let previewMaskLayer = CAShapeLayer()
        previewMaskLayer.path = UIBezierPath(ovalIn: preview.bounds).cgPath
        preview.layer.mask = previewMaskLayer
        
        // Заголовок и рецепт
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textColor = UserPreferences.textColor
        titleLabel.numberOfLines = 0
        
        ingredientsLabel.font = .systemFont(ofSize: 24)
        ingredientsLabel.textColor = UserPreferences.descriptionTextColor
        ingredientsLabel.numberOfLines = 0
        
        // Форма backButton
        backButton.layer.cornerRadius = backButton.bounds.height / 2
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UserPreferences.buttonColor.cgColor
        
        backButton.backgroundColor = UserPreferences.selectedButtonColor
        backButton.imageView?.tintColor = UserPreferences.selectedButtonTextColor
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        backButton.addTarget(self, action: #selector(exitRecipe), for: .touchUpInside)
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        contentViewTop.constant = -previewContainer.bounds.height / 2
    }
    
    @objc func exitRecipe() {
        presenter?.dismissRecipe()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: { [weak self] in
                self?.previewContainer.transform = (self?.previewContainer.transform.scaledBy(x: 0.8, y: 0.8))!
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: { [weak self] in
                self?.previewContainer.transform = .identity
            })
        }, completion: nil)
    }
    
    @objc func handlePress(_ sender: UITapGestureRecognizer) {
        if sender.state == .began {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.previewContainer.transform = (self?.previewContainer.transform.scaledBy(x: 0.8, y: 0.8))!
            })
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.previewContainer.transform = .identity
            })
        }
    }
}

extension RecipeView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let path = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
        let cornerMaskLayer = CAShapeLayer()
        cornerMaskLayer.path = path.cgPath
        cornerMaskLayer.fillColor = UIColor.white.cgColor
        
        cornerMaskLayer.shadowColor = UserPreferences.shadowColor.cgColor
        cornerMaskLayer.shadowPath = cornerMaskLayer.path
        cornerMaskLayer.shadowOffset = CGSize(width: 0, height: 1)
        cornerMaskLayer.shadowOpacity = 1
        cornerMaskLayer.shadowRadius = 10
        
        contentView.layer.backgroundColor = .none
        contentView.layer.sublayers?.remove(at: 0)
        contentView.layer.insertSublayer(cornerMaskLayer, at: 0)
    }
}

extension RecipeView: RecipeViewProtocol {
    
    func showRecipe(forMeal: MealModelShowed) {
        titleLabel?.text = forMeal.name
        ingredientsLabel?.text = forMeal.ingredients.enumerated().map { element -> String in
            if let ingredient = element.element {
                let str = "\(element.offset + 1). \(ingredient)\n"
                return str
            } else {
                return ""
            }
        }.joined()
        
        preview.af.setImage(withURL: URL(string: forMeal.preview)!)
    }
}
