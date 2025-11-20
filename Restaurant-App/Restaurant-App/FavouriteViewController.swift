//
//  FavouriteRestaurantViewController.swift
//  Restaurant-App
//
//  Created by SDC-USER on 20/11/25.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    
    var dataStore = DataStore.shared
    var favoriteRestaurants : [Restaurant] = []

    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteRestaurants = dataStore.getFavouriyeRestaurants()
        favouriteCollectionView.dataSource = self
        
    }
}
extension FavouriteViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoriteRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favourite_cell", for: indexPath) as! favouriteCollectionViewCell
        let restaurant = favoriteRestaurants[indexPath.row]
        cell.favRestaurantImage.image = UIImage(named: restaurant.images.first!)
        cell.favRestaurantLabel.text = restaurant.name
        return cell
    }
    
}
