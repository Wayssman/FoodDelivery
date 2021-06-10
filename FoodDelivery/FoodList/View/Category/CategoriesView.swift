//
//  CategoriesView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

final class CategoriesView: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - Private Properties
  private var categoryList: [String] = []
  private var selectedCategory: Int = 0
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = self
    collectionView.backgroundColor = UserPreferences.mainBackgroundColor
  }
  
  // MARK: - Public Methods
  func setCategoryList(list: [String]) {
    self.categoryList = list
  }
  
  func getCategory(at index: Int) -> String {
    return categoryList[index]
  }
  
  func processActiveCategory(name: String) {
    let categoryIndex = categoryList.firstIndex(of: name)
    guard let categoryIndex = categoryIndex else { return }
    setActiveCategory(index: categoryIndex)
  }
  
  func setActiveCategory(index: Int) {
    if index != selectedCategory {
      let tempIndexPath = IndexPath(item: selectedCategory, section: 0)
      selectedCategory = index
      let selectedIndexPath = IndexPath(item: index, section: 0)
      collectionView.reloadItems(at: [tempIndexPath, selectedIndexPath])
      collectionView.scrollToItem(at: selectedIndexPath, at: .right, animated: true)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension CategoriesView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    categoryList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
    cell.config(category: categoryList[indexPath.item], selected: indexPath.item == selectedCategory)
    
    return cell
  }
}
