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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        // Скроллить будем весь экран и таблицу отдельно
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        foodViewController.tableView.delegate = self
        foodViewController.tableView.isScrollEnabled = false
        
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
        }
    }
}

extension FoodListView: FoodListViewProtocol {
    
}
