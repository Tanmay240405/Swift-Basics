//
//  TopBeachCollectionViewCell.swift
//  TravelDestinationsApp
//
//  Created by SDC-USER on 21/11/25.
//

import UIKit

class TopBeachCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var beachImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        beachImageView.layer.cornerRadius = 15
        
    }
    
    func configureCell(destination: Destination) {
        beachImageView.image = UIImage(named: destination.imagePath)
        
    }

}
