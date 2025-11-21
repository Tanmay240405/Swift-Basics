//
//  ViewController.swift
//  TravelDestinationsApp
//
//  Created by SDC-USER on 21/11/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var destinationsResponse = DestinationsResponse()
    var topMountainDestinations: [Destination] = []
    var topUrbanDestinations: [Destination] = []
    var topBeachDestinations: [Destination] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()

        //get all destinations, mountaijn and urba
        topMountainDestinations = destinationsResponse.destinations(for: .mountains)
        topBeachDestinations = destinationsResponse.destinations(for: .beach)
        topUrbanDestinations = destinationsResponse.destinations(for: .urban)
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        collectionView.dataSource = self
//        collectionView.layer.cornerRadius = 34
//        collectionView.layer.masksToBounds = true
    }
    
    func generateLayout()->UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {section, env in
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            if section == 0 {
                //set item size
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                //create item
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
                //create the group
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
                
                //create the section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
                section.boundarySupplementaryItems = [headerItem]
                return section
                
            }
            else if section == 1 {
                //set item size
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                //create item
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
                //create the group
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)

                
                //create the section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
            else {
                //set item size
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                //create item
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)
                //create the group
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)

                //create the section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0)
                section.boundarySupplementaryItems = [headerItem]
                return section

            }
        }
       
        
        return layout
    }
    
    
    
    func registerCells() {
        collectionView.register( UINib(nibName: "TopBeachCollectionViewCell", bundle: nil ),forCellWithReuseIdentifier: "beach_cell")
        
        collectionView.register( UINib(nibName: "TopMountainCollectionViewCell", bundle: nil ),forCellWithReuseIdentifier: "mountain_cell")
        
        collectionView.register( UINib(nibName: "TopUrbanCollectionViewCell", bundle: nil ),forCellWithReuseIdentifier: "urban_cell")
        
        collectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "header_cell")
    }

}

extension ViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beach_cell", for: indexPath) as! TopBeachCollectionViewCell
            let destination = topBeachDestinations[indexPath.row]
            cell.configureCell(destination: destination)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mountain_cell", for: indexPath) as! TopMountainCollectionViewCell
            let destination = topMountainDestinations[indexPath.row]
            cell.configureCell(destination: destination)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "urban_cell", for: indexPath) as! TopUrbanCollectionViewCell
        let destination = topUrbanDestinations[indexPath.row]
        cell.configureCell(destination: destination)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topBeachDestinations.count
        }
        else if section == 1 {
            return topMountainDestinations.count
        }
        return topUrbanDestinations.count

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "header_cell", for: indexPath) as! HeaderView
        if indexPath.section == 0 {
            headerView.headerLabel.text = "Top Beaches"
        }
        else if indexPath.section == 1 {
            headerView.headerLabel.text = "Top Mountain"
        }
        else {
            headerView.headerLabel.text = "Top Urban Areas"
        }
        return headerView

    }
    
    
}


