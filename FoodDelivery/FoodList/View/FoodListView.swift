//
//  FoodListView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class FoodListView: UIViewController {
    
    var presenter: FoodListPresenterProtocol?

    @IBOutlet weak var scrollViewContent: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var foodViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var bannerView: UIView!
    
    private var categoriesViewController: CategoriesView!
    private var foodViewController: FoodView!
    private var bannerViewController: BannerView!
    
    private lazy var path = UIBezierPath(roundedRect:foodView.bounds,
                                         byRoundingCorners:[.topRight, .topLeft],
                                         cornerRadii: CGSize(width: 20, height:  20))
    private let maskLayer = CAShapeLayer()
    
    private var lock = false
    private var startPos: CGFloat = 0.0
    private var shift: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        scrollView.addGestureRecognizer(panGestureRecognizer)
        scrollView.isScrollEnabled = false
        
        // Отслеживаем прокрутку ячеек таблицы
        foodViewController.tableView.delegate = self
        foodViewController.tableView.isScrollEnabled = false
        
        // Отслеживаем нажатия по subview
        categoriesViewController.collectionView.delegate = self
        
        // Задаем цвета
        view.backgroundColor = UserPreferences.mainBackgroundColor
        scrollViewContent.backgroundColor = UserPreferences.mainBackgroundColor
        
        // Подготавливаем тень
        categoriesView.layer.shadowColor = UserPreferences.shadowColor.cgColor
        categoriesView.layer.shadowOpacity = 0
        categoriesView.layer.shadowOffset = .zero
        categoriesView.layer.shadowRadius = 14
        
        // Подготавливаем скругление углов
        maskLayer.path = path.cgPath
        foodView.layer.mask = maskLayer
    }
    
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
    
    func processTopCell(row: Int) {
        // Т.к. FoodListView - ScrollDelegate для FoodView, обрабатываем в ней
        let category = foodViewController.foodList[row].category
        categoriesViewController.processActiveCategory(name: category)
    }
    
    @objc func onPan(recognizer: UIPanGestureRecognizer) {
        let bannerHeight = bannerView.frame.height
        
        switch recognizer.state {
        case .began:
            if scrollView.contentOffset.y < bannerHeight {
                startPos = scrollView.contentOffset.y
                shift = bannerHeight
            } else {
                startPos = foodViewController.tableView.contentOffset.y
                shift = 0
            }
        case .changed:
            // BannerView
            if startPos - recognizer.translation(in: scrollView).y < bannerHeight {
                if startPos - recognizer.translation(in: scrollView).y >= 0 {
                    scrollView.contentOffset.y = startPos - recognizer.translation(in: scrollView).y
                } else {
                    scrollView.contentOffset.y = 0
                }
            } else {
                scrollView.contentOffset.y = bannerHeight
                // Меняем внешний вид
                categoriesView.layer.shadowOpacity = 1
                foodView.layer.mask = nil
            }
            
            // TableView
            if startPos - shift - recognizer.translation(in: scrollView).y > 0 {
                let contentHeight = foodViewController.tableView.rowHeight * CGFloat(foodViewController.foodList.count)
                let visibleHeight = foodViewController.tableView.visibleSize.height
                
                if startPos - shift - recognizer.translation(in: scrollView).y <= contentHeight - visibleHeight {
                    foodViewController.tableView.contentOffset.y = startPos - shift - recognizer.translation(in: scrollView).y
                } else {
                    foodViewController.tableView.contentOffset.y = contentHeight - visibleHeight
                }
            } else {
                foodViewController.tableView.contentOffset.y = 0
                // Меняем внешний вид обратно
                self.categoriesView.layer.shadowOpacity = 0
                foodView.layer.mask = maskLayer
            }
        default: break
        }
    }
}

extension FoodListView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Определяем верхнюю ячейку, если скролл не занят действием переключения между категориями
        if lock == false {
            let row = self.foodViewController.tableView.indexPathsForVisibleRows?[0].row ?? 0
            processTopCell(row: row)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // Запускаем отслеживание после анимации
        lock = false
    }
}

extension FoodListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoriesViewController.setActiveCategory(index: indexPath.item)
        
        let categoryName = categoriesViewController.categoryList[indexPath.item]
        lock = true
        foodViewController.processActiveCategory(name: categoryName)
    }
}

extension FoodListView: FoodListViewProtocol {
    func showFood(meals: [MealModelShowed]) {
        foodViewController.foodList = meals
        foodViewController.tableView.reloadData()
        
        // Убираем повторы и передаем
        var set = Set<String>()
        categoriesViewController.categoryList = meals.map{ $0.category }.filter { set.insert($0).inserted }
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
