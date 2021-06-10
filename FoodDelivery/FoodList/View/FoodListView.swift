//
//  FoodListView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

final class FoodListView: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet private weak var scrollViewContent: UIView!
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var foodView: UIView!
  @IBOutlet private weak var foodViewHeight: NSLayoutConstraint!
  @IBOutlet private weak var categoriesView: UIView!
  @IBOutlet private weak var bannerView: UIView!
  
  // MARK: - Public Properties
  var presenter: FoodListPresenterProtocol?
  
  // MARK: - Private Properties
  private var bannerViewController: BannerView!
  private var categoriesViewController: CategoriesView!
  private var foodViewController: FoodView!
  
  private lazy var path = UIBezierPath(roundedRect:foodView.bounds,
                                       byRoundingCorners:[.topRight, .topLeft],
                                       cornerRadii: CGSize(width: 20, height:  20))
  private let maskLayer = CAShapeLayer()
  
  private var tableStartPos: CGFloat = 0.0
  private var viewStartPos: CGFloat = 0.0
  private var tableShift: CGFloat = 0.0
  private var viewShift: CGFloat = 0.0
  private var lock = false
  private var trigger: Bool = true {
    didSet {
      // Меняем внешний вид
      if trigger {
        self.categoriesView.layer.shadowOpacity = 0
        foodView.layer.mask = maskLayer
      } else {
        categoriesView.layer.shadowOpacity = 1
        foodView.layer.mask = nil
      }
    }
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
    scrollView.addGestureRecognizer(panGestureRecognizer)
    scrollView.isScrollEnabled = false
    
    // Отслеживаем прокрутку ячеек таблицы
    foodViewController.tableView.delegate = self
    foodViewController.tableView.isScrollEnabled = false
    foodViewController.tableView.allowsSelection = true
    
    // Отслеживаем нажатия по subview
    categoriesViewController.collectionView.delegate = self
    
    setupUI()
    
    presenter?.viewDidLoad()
  }
  
  
  // MARK: - Public Methods
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Получаем доступ к дочерним вью контроллерам
    if let bannerVC = segue.destination as? BannerView, segue.identifier == "BannerViewSegue" {
      self.bannerViewController = bannerVC
    }
    if let categoriesVC = segue.destination as? CategoriesView, segue.identifier == "CategoriesViewSegue" {
      self.categoriesViewController = categoriesVC
    }
    if let foodVC = segue.destination as? FoodView, segue.identifier == "FoodViewSegue" {
      self.foodViewController = foodVC
    }
  }
  
  // MARK: - Private Methods
  private func setupUI() {
    // Задаем цвета
    view.backgroundColor = UserPreferences.mainBackgroundColor
    scrollViewContent.backgroundColor = UserPreferences.mainBackgroundColor
    
    // Подготавливаем тень
    categoriesView.layer.shadowColor = UserPreferences.shadowColor.cgColor
    categoriesView.layer.shadowOpacity = 0
    categoriesView.layer.shadowOffset = CGSize(width: 0, height: 0)
    categoriesView.layer.shadowRadius = 10
    
    // Подготавливаем скругление углов
    maskLayer.path = path.cgPath
    foodView.layer.mask = maskLayer
  }
  
  private func processTopCell(row: Int) {
    // Т.к. FoodListView - ScrollDelegate для FoodView, обрабатываем в ней
    let category = foodViewController.getMeal(at: row).category
    categoriesViewController.processActiveCategory(name: category)
  }
  
  @objc private func onPan(recognizer: UIPanGestureRecognizer) {
    let bannerHeight = bannerView.frame.height
    let translation = recognizer.translation(in: scrollView).y
    
    switch recognizer.state {
    case .began:
      viewStartPos = scrollView.contentOffset.y
      tableStartPos = foodViewController.tableView.contentOffset.y
      // Сдвиги, если скролл был начат в одном ScrollView, а закончен в другом
      if trigger {
        tableShift = bannerHeight
        viewShift = 0
      } else {
        tableShift = 0
        viewShift = tableStartPos
      }
    case .changed:
      // BannerView
      if trigger {
        if viewStartPos + viewShift - translation < bannerHeight {
          if viewStartPos + viewShift - translation >= 0 {
            scrollView.contentOffset.y = viewStartPos + viewShift - translation
          } else {
            scrollView.contentOffset.y = 0
          }
        } else {
          scrollView.contentOffset.y = bannerHeight
          trigger = false
        }
      }
      
      // TableView
      if !trigger {
        if tableStartPos - tableShift - translation > 0 {
          let contentHeight = foodViewController.tableView.rowHeight * CGFloat(foodViewController.getMealsCount())
          let visibleHeight = foodViewController.tableView.visibleSize.height
          
          if tableStartPos - tableShift - translation <= contentHeight - visibleHeight {
            foodViewController.tableView.contentOffset.y = tableStartPos - tableShift - translation
          } else {
            foodViewController.tableView.contentOffset.y = contentHeight - visibleHeight
          }
        } else {
          foodViewController.tableView.contentOffset.y = 0
          trigger = true
        }
      }
    default: break
    }
  }
}

// MARK: - UITableViewDelegate
extension FoodListView: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Определяем верхнюю ячейку, если скролл не занят действием переключения между категориями
    if lock == false {
      let row = self.foodViewController.tableView.indexPathsForVisibleRows?[0].row ?? 0
      processTopCell(row: row)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let meal = foodViewController.getMeal(at: indexPath.row)
    presenter?.showRecipe(forMeal: meal)
  }
}

// MARK: - UICollectionViewDelegate
extension FoodListView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    categoriesViewController.setActiveCategory(index: indexPath.item)
    
    scrollView.setContentOffset(CGPoint(x: 0, y: bannerView.frame.height), animated: true)
    trigger = false
    
    lock = true
    let categoryName = categoriesViewController.getCategory(at: indexPath.item)
    foodViewController.processActiveCategory(name: categoryName)
    // Даем время на анимацию и разблокируем скролл
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
      self?.lock = false
    })
  }
}

// MARK: - ViewProtocol
extension FoodListView: FoodListViewProtocol {
  func showFood(meals: [MealObject]) {
    foodViewController.setFoodList(list: meals)
    foodViewController.tableView.reloadData()
    
    // Убираем повторы и передаем
    var set = Set<String>()
    let categories = meals.map{ $0.category }.filter { set.insert($0).inserted }
    categoriesViewController.setCategoryList(list: categories)
    categoriesViewController.collectionView.reloadData()
  }
  
  func showError() {
    // Можно вывести ошибку пользователю
    let message = UIAlertController(title: nil, message: "Ошибка сети", preferredStyle: .alert)
    let action = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
    message.addAction(action)
    self.navigationController?.present(message, animated: true, completion: nil)
  }
  
  func showLoading() {
    let message = UIAlertController(title: "Загрузка...", message: nil, preferredStyle: .alert)
    
    let activity = UIActivityIndicatorView()
    activity.startAnimating()
    
    message.view.addSubview(activity)
    activity.translatesAutoresizingMaskIntoConstraints = false
    activity.centerYAnchor.constraint(equalTo: message.view.centerYAnchor).isActive = true
    activity.leadingAnchor.constraint(equalTo: message.view.leadingAnchor, constant: 20).isActive = true
    
    
    self.navigationController?.present(message, animated: true, completion: nil)
  }
  
  func hideLoading() {
    if let message = self.navigationController?.presentedViewController as? UIAlertController {
      message.dismiss(animated: true, completion: nil)
    }
  }
}
