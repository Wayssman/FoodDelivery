//
//  FoodListView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit
import PKHUD

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
    private var startPosition: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        // Скроллить будем весь экран и таблицу отдельно
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
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
}

extension FoodListView: UITableViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenHeight = UIScreen.main.bounds.height
        
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y >= bannerView.frame.height {
                // Останавливаем скролл на этом месте
                scrollView.contentOffset.y = bannerView.frame.height
                scrollView.isScrollEnabled = false
                // Таблица занимает все место на экране, кроме места для категорий
                self.foodViewHeight.constant = screenHeight - categoriesView.frame.height
                self.foodViewController.tableView.isScrollEnabled = true
                // Меняем внешний вид
                self.categoriesView.layer.shadowOpacity = 1
                foodView.layer.mask = nil
            } else {
                // Меняем внешний вид обратно
                self.categoriesView.layer.shadowOpacity = 0
                foodView.layer.mask = maskLayer
            }
        }
        
        if scrollView == self.foodViewController.tableView {
            if scrollView.contentOffset.y <= 0 {
                // Останавливаем скролл
                scrollView.contentOffset.y = 0
                scrollView.isScrollEnabled = false
                // Растягиваем таблицу, чтобы было куда скроллить главный экран
                self.foodViewHeight.constant = 800
                self.scrollView.isScrollEnabled = true
            }
            // Определяем верхнюю ячейку
            let row = self.foodViewController.tableView.indexPathsForVisibleRows?[0].row ?? 0
            processTopCell(row: row)
        }
    }
}

extension FoodListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoriesViewController.setActiveCategory(index: indexPath.item)
        
        let categoryName = categoriesViewController.categoryList[indexPath.item]
        foodViewController.processActiveCategory(name: categoryName)
    }
}

extension FoodListView: FoodListViewProtocol {
    func showFood(meals: [MealModelShowed]) {
        print(meals)
        foodViewController.foodList = meals
        foodViewController.tableView.reloadData()
        
        // Убираем повторы и передаем
        var set = Set<String>()
        categoriesViewController.categoryList = meals.map{ $0.category }.filter { set.insert($0).inserted }
        categoriesViewController.collectionView.reloadData()
    }
    
    func showError() {
        HUD.flash(.label("Ошибка при загрузке данных!"), delay: 2.0)
    }
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func hideLoading() {
        HUD.hide()
    }
}
