//
//  RestaurantCollectionViewCell.swift
//  Restaurant-App
//
//  Created by SDC-USER on 19/11/25.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    func configureCell(restaurant: Restaurant){
        imageView.image = UIImage(named: restaurant.images.first ?? "")
        restaurantNameLabel.text = restaurant.name
    }
}
