import UIKit

class ViewController: UIViewController,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataStore = NewsDataStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    
 
    func generateLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            
          
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            
          
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),   
                heightDimension: .absolute(500)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            
           
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            return section
        }
    }
    
    
    
   
    func registerCells() {

    }
}



extension ViewController {
    
 
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataStore.getAllNews().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TodaysPickCollectionViewCell",
            for: indexPath
        ) as! TodaysPickCollectionViewCell
        
        let article = dataStore.getAllNews()[indexPath.item]
        cell.configureCell(with: article)
        
        return cell
    }
}
