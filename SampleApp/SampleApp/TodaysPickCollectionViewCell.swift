import UIKit

class TodaysPickCollectionViewCell: UICollectionViewCell {
    

    
    @IBOutlet weak var pickLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 0
        contentView.layer.masksToBounds = true
        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.layer.cornerRadius = 0
        newsImageView.clipsToBounds = true
        
        pickLabel.textColor = .systemGray
        pickLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        headlineLabel.numberOfLines = 2
        headlineLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
//    func dominantColor(from image: UIImage) -> UIColor? {
//        guard let inputImage = CIImage(image: image) else { return nil }
//
//        let extent = inputImage.extent
//        let parameters = [kCIInputImageKey: inputImage]
//
//        guard let filter = CIFilter(name: "CIAreaAverage", parameters: parameters) else { return nil }
//        filter.setValue(CIVector(cgRect: extent), forKey: kCIInputExtentKey)
//
//        guard let outputImage = filter.outputImage else { return nil }
//
//        var bitmap = [UInt8](repeating: 0, count: 4)
//        let context = CIContext(options: [.workingColorSpace: kCFNull!])
//
//        context.render(outputImage,
//                       toBitmap: &bitmap,
//                       rowBytes: 4,
//                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
//                       format: .RGBA8,
//                       colorSpace: nil)
//
//        // Extract RGBA
//        return UIColor(
//            red: CGFloat(bitmap[0]) / 255,
//            green: CGFloat(bitmap[1]) / 255,
//            blue: CGFloat(bitmap[2]) / 255,
//            alpha: 1
//        )
//    }
//    
//    func applyStrongGradient(using color: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bounds
//
//        gradientLayer.colors = [
//            UIColor.clear.cgColor,                          // top: no fade
//            color.withAlphaComponent(0.8).cgColor,          // mid fade
//            color.darker(by: 30)?.cgColor           // bottom: full color
//        ]
//
//        gradientLayer.locations = [
//            0.0,   // 0% of the cell: image visible
//            0.6,  // 55%: mixed fade
//            1.0    // bottom: full solid color
//        ]
//
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//
//        // remove old gradients
//        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
//        self.layer.insertSublayer(gradientLayer, above: self.newsImageView.layer)
//    }
    
    func configureCell(with article: NewsArticle) {
        
        newsImageView.image = UIImage(named: article.imageName)
//        if let img = newsImageView.image,
//               let prominentColor = dominantColor(from: img) {
//            applyStrongGradient(using: prominentColor)
//            }
        pickLabel.text = "Today's Pick"
        headlineLabel.text = article.title
    }
}
