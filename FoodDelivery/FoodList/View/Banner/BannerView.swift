//
//  BannerView.swift
//  FoodDelivery
//
//  Created by Желанов Александр Валентинович on 15.05.2021.
//

import UIKit

class BannerView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.backgroundColor = UserPreferences.mainBackgroundColor
    }
}

extension BannerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.bannerImage.contentMode = .scaleAspectFill
        cell.bannerImage.image = UIImage(named: "banner\(indexPath.item + 1)")
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    
}
