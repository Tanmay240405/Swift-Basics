import UIKit

class TodaysPickCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pickLabel: UILabel!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    private var gradientLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.clipsToBounds = true
        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        
        pickLabel.textColor = .gray
        pickLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        

        headlineLabel.numberOfLines = 2
        headlineLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        headlineLabel.textColor = .black
    }
    
    
    // MARK: - Dominant Color
    func dominantColor(from image: UIImage) -> UIColor? {
        guard let inputImage = CIImage(image: image) else { return nil }
        
        let extent = inputImage.extent
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage,
                                                 kCIInputExtentKey: CIVector(cgRect: extent)]) else { return nil }
        
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: 1)
    }
    
    
    // MARK: - Apply Gradient
    private func applyGradient(using color: UIColor) {
        
        // Remove old gradient
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        
        gradient.colors = [
            UIColor.clear.cgColor,
            color.withAlphaComponent(0.75).cgColor,
            color.withAlphaComponent(1.0).cgColor
        ]
        
        gradient.locations = [0.0, 0.55, 1.0]
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1)
        
        // Put gradient ABOVE image but BELOW labels
        contentView.layer.insertSublayer(gradient, above: newsImageView.layer)
        
        self.gradientLayer = gradient
    }
    
    
    // MARK: - Update for layout changes
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = contentView.bounds
    }
    
    
    // MARK: - Configure Cell
    func configureCell(with article: NewsArticle) {
        
        newsImageView.image = UIImage(named: article.imageName)
        
        if let img = newsImageView.image,
           let color = dominantColor(from: img) {
            applyGradient(using: color)
        }
        
        pickLabel.text = "Today's Pick"
        headlineLabel.text = article.title
    }
}
