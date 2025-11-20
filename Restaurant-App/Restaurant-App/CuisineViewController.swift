//
//  CuisineViewController.swift
//  Restaurant-App
//
//  Created by SDC-USER on 20/11/25.
//

import UIKit

class CuisineViewController: UIViewController, UICollectionViewDataSource {

    
    
    var cuisines: [CuisineType] = CuisineType.allCases
    
    
    
    @IBOutlet weak var cuisineCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cuisineCollectionView.dataSource = self
        //downcast the UICollectionViewLayout to UIColllectionViewFlowLayout
        
        
                if let flowLayout = cuisineCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    //incase you want ot use item size property,you have to disable self sizing
                    flowLayout.estimatedItemSize = .zero
        
                    //set the item size for the flow layout
                    flowLayout.itemSize = CGSize(width: 370, height: 200)
        
                }

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //create a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cuisine_cell", for: indexPath) as! CuisineCollectionViewCell
        let cuisine = cuisines[indexPath.row]
        //Configure a cell
        cell.CuisineLabel.text = cuisine.rawValue
        cell.CuisineImage.image = UIImage(named: cuisine.imageName)
        cell.CuisineImage.layer.cornerRadius = 34.0
        cell.CuisineImage.clipsToBounds = true
            
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedIndexPath = cuisineCollectionView.indexPathsForSelectedItems else { return }
        guard let selectedIndexPath = selectedIndexPath.first else { return }
        
        let cuisine = cuisines[selectedIndexPath.row]
        print("selected \(cuisine)")
        
        guard let restaurantVC = segue.destination as? RestaurantViewController else { return }
        
        restaurantVC.cuisineType = cuisine
        
    }
}

