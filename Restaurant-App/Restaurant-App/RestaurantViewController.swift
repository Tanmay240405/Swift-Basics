//
//  ViewController.swift
//  Restaurant-App
//
//  Created by SDC-USER on 19/11/25.
//

import UIKit

class RestaurantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var dataStore: DataStore = DataStore.shared
    var cuisineType: CuisineType?
    var restaurants: [Restaurant] = []
    var restaurant: Restaurant?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the count of restaurants
        self.restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurant_cell", for: indexPath)
        restaurant = restaurants[indexPath.row]
        guard let restaurantCell = cell as? RestaurantCollectionViewCell else {
            return cell
        }
        
        let restaurant = restaurants[indexPath.row]
        restaurantCell.configureCell(restaurant: restaurant)
        return cell
    }
    
    
    
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        restaurantCollectionView.dataSource = self
        restaurantCollectionView.delegate = self
        guard let cuisinetype = self.cuisineType else { return }
        self.restaurants = dataStore.filter(for: cuisineType!)
        
        let layout = generateLayout()
        restaurantCollectionView.setCollectionViewLayout(layout, animated: true)
        //  dataStore.getRestaurants()
        
        
        //downcast the UICollectionViewLayout to UIColllectionViewFlowLayout
        //
        //
        //        if let flowLayout = restaurantCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        //            //incase you want ot use item size property,you have to disable self sizing
        //            flowLayout.estimatedItemSize = .zero
        //
        //            //set the item size for the flow layout
        //            flowLayout.itemSize = CGSize(width: 150, height: 200)
        //
        //        }
        
        //restaurantCollectionView.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        //tell the collection view who the data Source is
        
               restaurantCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        //}
        
        func generateLayout() -> UICollectionViewLayout{
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            
            
            let item = NSCollectionLayoutItem(layoutSize: size)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
            
        }
    }
    func markAsFavourite() {

            guard var r = restaurant
        else {
                return
            }

            r.isFavourite = true
            print("Restaurant marked as favourite:", r.name)
    }
    @IBAction func addToFav(_ sender: UIButton) {
        markAsFavourite()
    }
    
}


