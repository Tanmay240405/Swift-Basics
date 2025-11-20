//
//  FavouriteCollectionViewCell.swift
//  Restaurant-App
//
//  Created by SDC-USER on 20/11/25.
//

import UIKit

class favouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favRestaurantImage: UIImageView!
    
    @IBOutlet weak var favRestaurantLabel: UILabel!
    

    
    func configureFavouriteCell(restaurant: Restaurant) {
            favRestaurantImage.image = UIImage(named: restaurant.images.first ?? "")
            favRestaurantLabel.text = restaurant.name

            favRestaurantImage.layer.cornerRadius = 20
            favRestaurantImage.clipsToBounds = true
        }
}
