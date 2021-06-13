//
//  ReceipView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 28.05.2021.
//

import UIKit
import AlamofireImage

final class RecipeView: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollContentView: UIView!
  @IBOutlet weak var previewContainer: UIView!
  @IBOutlet weak var previewContainerTop: NSLayoutConstraint!
  @IBOutlet weak var preview: UIImageView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var ingredientsLabel: UILabel!
  @IBOutlet weak var recipeLabel: UILabel!
  @IBOutlet weak var contentViewTop: NSLayoutConstraint!
  @IBOutlet weak var backButton: UIButton!
  
  // MARK: - Public Properties
  var presenter: RecipePresenterProtocol?
  
  // MARK: - Private Properties
  private var previewMode: Bool = false {
    didSet {
      animatePreview()
    }
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    preview.addGestureRecognizer(tapGestureRecognizer)
    preview.isUserInteractionEnabled = true
    
    setupUI()
    
    presenter?.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    contentViewTop.constant = -previewContainer.bounds.height / 2
  }
  
  // MARK: - Private Methods
  @objc private func exitRecipe() {
    presenter?.dismissRecipe()
  }
  
  @objc private func handleTap(_ sender: UITapGestureRecognizer) {
    previewMode = previewMode ? false : true
  }
  
  private func setupUI() {
    // Задаем стиль
    view.backgroundColor = UserPreferences.mainBackgroundColor
    scrollContentView.backgroundColor = UserPreferences.mainBackgroundColor
    preview.backgroundColor = .white
    
    // Тень previewContainer
    previewContainer.backgroundColor = .none
    previewContainer.layer.shadowColor = UIColor.black.cgColor
    previewContainer.layer.shadowPath = UIBezierPath(ovalIn: previewContainer.bounds).cgPath
    previewContainer.layer.shadowOffset = .zero
    previewContainer.layer.shadowOpacity = 1
    previewContainer.layer.shadowRadius = 5
    
    // Форма preview
    let previewMaskLayer = CAShapeLayer()
    previewMaskLayer.path = UIBezierPath(ovalIn: preview.bounds).cgPath
    preview.layer.mask = previewMaskLayer
    
    // Заголовок и рецепт
    titleLabel.font = .boldSystemFont(ofSize: 32)
    titleLabel.textColor = UserPreferences.textColor
    titleLabel.numberOfLines = 0
    
    ingredientsLabel.font = .systemFont(ofSize: 16)
    ingredientsLabel.textColor = UserPreferences.descriptionTextColor
    ingredientsLabel.numberOfLines = 0
    
    recipeLabel.font = .systemFont(ofSize: 18)
    recipeLabel.textColor = UserPreferences.textColor
    recipeLabel.textAlignment = .justified
    recipeLabel.numberOfLines = 0
    
    // Форма backButton
    backButton.layer.cornerRadius = backButton.bounds.height / 2
    backButton.layer.borderWidth = 1
    backButton.layer.borderColor = UserPreferences.buttonColor.cgColor
    
    backButton.backgroundColor = UserPreferences.selectedButtonColor
    backButton.imageView?.tintColor = UserPreferences.selectedButtonTextColor
    backButton.addTarget(self, action: #selector(exitRecipe), for: .touchUpInside)
  }
  
  private func animatePreview() {
    // Считаем размеры View, куда впишем маску
    let newEdge = preview.bounds.width * sqrt(2)
    let shift = newEdge / 2 - preview.bounds.width / 2
    let newRect = CGRect(x: preview.bounds.minX - shift, y: preview.bounds.minY - shift, width: newEdge, height: newEdge)
    
    // Заготавливаем cgPaths
    let smallOval = UIBezierPath(ovalIn: preview.bounds).cgPath
    let bigOval = UIBezierPath(ovalIn: newRect).cgPath
    let corners = UIBezierPath(roundedRect: preview.bounds, cornerRadius: 20).cgPath
    var endPath: CGPath?
    
    let maskAnimation = CABasicAnimation(keyPath: "path")
    maskAnimation.delegate = self // Отслеживаем окончание анимации
    maskAnimation.duration = 0.25
    maskAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    
    previewContainer.layer.shadowOpacity = 0
    
    if previewMode {
      maskAnimation.fromValue = smallOval
      maskAnimation.toValue = bigOval
      endPath = corners
    } else {
      maskAnimation.fromValue = bigOval
      maskAnimation.toValue = smallOval
      endPath = smallOval
    }
    preview.layer.mask?.add(maskAnimation, forKey: "path")
    (preview.layer.mask as? CAShapeLayer)?.path = endPath
    previewContainer.layer.shadowPath = endPath
  }
}

// MARK: - UIScrollViewDelegate
extension RecipeView: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.layoutIfNeeded()
    
    // Тень и форма contentView динамически подстраиваются
    let screenHeight = UIScreen.main.bounds.height
    let heightAvalible = screenHeight - (previewContainerTop.constant + previewContainer.bounds.height / 2)
    var rectAvalible = CGRect(x: contentView.bounds.minX, y: contentView.bounds.minY, width: contentView.bounds.width, height: heightAvalible)
    rectAvalible = contentView.bounds.height > heightAvalible ? contentView.bounds : rectAvalible
    
    let path = UIBezierPath(roundedRect: rectAvalible, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20))
    let cornerMaskLayer = CAShapeLayer()
    cornerMaskLayer.path = path.cgPath
    cornerMaskLayer.fillColor = UIColor.white.cgColor
    
    cornerMaskLayer.shadowColor = UserPreferences.shadowColor.cgColor
    cornerMaskLayer.shadowPath = cornerMaskLayer.path
    cornerMaskLayer.shadowOffset = CGSize(width: 0, height: 1)
    cornerMaskLayer.shadowOpacity = 1
    cornerMaskLayer.shadowRadius = 10
    
    contentView.layer.backgroundColor = .none
    if let sublayers = contentView.layer.sublayers {
      for layer in sublayers {
        if layer.name == "cornerMaskLayer" {
          layer.removeFromSuperlayer()
        }
      }
    }
    
    cornerMaskLayer.name = "cornerMaskLayer"
    contentView.layer.insertSublayer(cornerMaskLayer, at: 0)
  }
}

// MARK: - CAAnimationDelegate
extension RecipeView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    previewContainer.layer.shadowOpacity = 1
  }
}

// MARK: - ViewProtocol
extension RecipeView: RecipeViewProtocol {
  func showRecipe(forMeal: MealObject) {
    titleLabel?.text = forMeal.name
    ingredientsLabel?.text = forMeal.ingredients.compactMap{$0}.filter{ $0.count > 0 }.enumerated().map { "\($0.offset + 1). \($0.element)\n" }.joined()
    recipeLabel?.text = forMeal.recipe
    let placeholder = UIImage(named: "placeholder")
    preview.af.setImage(withURL: URL(string: forMeal.preview)!, placeholderImage: placeholder)
  }
}
