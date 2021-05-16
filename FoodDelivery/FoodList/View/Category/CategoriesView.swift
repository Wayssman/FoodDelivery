//
//  CategoriesView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class CategoriesView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryList: [String] = []
    private var selectedCategory: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.backgroundColor = UserPreferences.mainBackgroundColor
    }
    
    func processActiveCategory(name: String) {
        let categoryIndex = categoryList.firstIndex(of: name)
        guard let category = categoryIndex else { return }
        setActiveCategory(index: category)
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
