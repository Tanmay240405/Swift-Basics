//
//  ViewController.swift
//  swiftChallenge
//
//  Created by SDC-USER on 30/01/26.
//

import UIKit
import Vision
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var imageFrame: CGRect = .zero
    var faceRect: CGRect = .zero
    let outlineImageView = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false
        setupOverlay()

    }
    func setupOverlay() {
        outlineImageView.backgroundColor = .clear
        outlineImageView.contentMode = .scaleToFill
        outlineImageView.isUserInteractionEnabled = false
        imageView.addSubview(outlineImageView)
    }
    
    @IBAction func pickImageTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image

        imageView.layoutIfNeeded()
        outlineImageView.frame = imageFrameInImageView(imageView)
        outlineImageView.image = nil

        processImage(image)
    }
    func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        // 1️⃣ Handle Orientation (Crucial!)
        // Standard CGImage loses orientation; we must recover it from the UIImage
        let orientation = CGImagePropertyOrientation(image.imageOrientation)

        // 2️⃣ Person Segmentation Request
        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .balanced
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8

        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])
        
        do {
            try handler.perform([request])
            
            guard let maskBuffer = request.results?.first?.pixelBuffer else {
                print("No person found in image")
                return
            }
            
            // 3️⃣ Generate Outline using Core Image (Fast & Clean)
            drawFaceOutline(from: maskBuffer, originalOrientation: image.imageOrientation)
            
        } catch {
            print("Vision request failed: \(error)")
        }
    }
func imageFrameInImageView(_ imageView: UIImageView) -> CGRect {
    guard let image = imageView.image else { return .zero }

    let imageRatio = image.size.width / image.size.height
    let viewRatio = imageView.bounds.width / imageView.bounds.height

    if imageRatio > viewRatio {
        let width = imageView.bounds.width
        let height = width / imageRatio
        let y = (imageView.bounds.height - height) / 2
        return CGRect(x: 0, y: y, width: width, height: height)
    } else {
        let height = imageView.bounds.height
        let width = height * imageRatio
        let x = (imageView.bounds.width - width) / 2
        return CGRect(x: x, y: 0, width: width, height: height)
    }
}
    func drawFaceOutline(from pixelBuffer: CVPixelBuffer, originalOrientation: UIImage.Orientation) {
        let ciContext = CIContext()
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // 1. Create Edges from the Mask
        guard let edgesFilter = CIFilter(name: "CIEdges") else { return }
        edgesFilter.setValue(ciImage, forKey: kCIInputImageKey)
        edgesFilter.setValue(30.0, forKey: kCIInputIntensityKey) // Adjust for thicker/thinner lines
        guard let edgesImage = edgesFilter.outputImage else { return }

        // 2. Make non-edges transparent (White lines on Transparent background)
        // 2. Make non-edges transparent
        guard let maskFilter = CIFilter(name: "CIMaskToAlpha") else { return }
        maskFilter.setValue(edgesImage, forKey: kCIInputImageKey)
        guard let alphaMask = maskFilter.outputImage else { return }

        // 3. THICKEN the lines using morphology
        guard let thickFilter = CIFilter(name: "CIMorphologyMaximum") else { return }
        thickFilter.setValue(alphaMask, forKey: kCIInputImageKey)
        thickFilter.setValue(2.0, forKey: "inputRadius") // 🔥 THIS controls thickness
        guard let thickImage = thickFilter.outputImage else { return }

        // 3. Render the CIImage to a UIImage
        if let cgResult = ciContext.createCGImage(alphaMask, from: alphaMask.extent) {
            
            // We must respect the original photo's orientation when creating the final UIImage
            let finalImage = UIImage(cgImage: cgResult, scale: 1.0, orientation: originalOrientation)
            
            DispatchQueue.main.async {
                self.outlineImageView.image = finalImage
                self.outlineImageView.tintColor = .white
            }
        }
    }

    
    // MARK: - Face Detection
    
    func detectFace(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let landmarksRequest = VNDetectFaceLandmarksRequest { [weak self] request, _ in
            guard let self = self,
                  let face = request.results?.first as? VNFaceObservation else { return }
            
            self.imageFrame = self.imageFrameInImageView()
            self.faceRect = self.calculateFaceRect(face: face, imageFrame: self.imageFrame)
            
            DispatchQueue.main.async {
                // Draw Step 1: Guide Cross
                self.drawStep1GuideLines(for: face)

            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        try? handler.perform([landmarksRequest])
    }
    
    // MARK: - STEP 1: Guide Cross Lines
    
    func drawStep1GuideLines(for face: VNFaceObservation) {
        overlayView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        guard let landmarks = face.landmarks,
              let leftEye = landmarks.leftEye,
              let rightEye = landmarks.rightEye else { return }
        
        let leftEyePoints = leftEye.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
        let rightEyePoints = rightEye.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
        
        let leftEyeCenter = calculateCenter(of: leftEyePoints)
        let rightEyeCenter = calculateCenter(of: rightEyePoints)
        
        let faceAngle = atan2(rightEyeCenter.y - leftEyeCenter.y, rightEyeCenter.x - leftEyeCenter.x)
        
        // Draw horizontal eye line
        drawHorizontalEyeLine(from: leftEyeCenter, to: rightEyeCenter, faceRect: faceRect)
        
        let eyesMidpoint = CGPoint(
            x: (leftEyeCenter.x + rightEyeCenter.x) / 2,
            y: (leftEyeCenter.y + rightEyeCenter.y) / 2
        )
        
        // Draw vertical center line
        drawVerticalCenterLine(
            midpoint: eyesMidpoint,
            faceRect: faceRect,
            landmarks: landmarks,
            faceAngle: faceAngle
        )
        
        // Draw intersection point
        drawIntersectionPoint(at: eyesMidpoint)
//        drawJawline(for: face)
    }
    
    func drawHorizontalEyeLine(from leftEye: CGPoint, to rightEye: CGPoint, faceRect: CGRect) {
        let path = UIBezierPath()
        
        let angle = atan2(rightEye.y - leftEye.y, rightEye.x - leftEye.x)
        
        let midX = (leftEye.x + rightEye.x) / 2
        let midY = (leftEye.y + rightEye.y) / 2
        
        let lineLength = faceRect.width
        
        let halfLength = lineLength / 2
        let startX = midX - halfLength * cos(angle)
        let startY = midY - halfLength * sin(angle)
        let endX = midX + halfLength * cos(angle)
        let endY = midY + halfLength * sin(angle)
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.cyan.cgColor
        lineLayer.lineWidth = 2.5
        lineLayer.lineCap = .round
        lineLayer.name = "step1_horizontal"
        
        overlayView.layer.addSublayer(lineLayer)
    }
    
    func drawVerticalCenterLine(midpoint: CGPoint, faceRect: CGRect, landmarks: VNFaceLandmarks2D, faceAngle: CGFloat) {
        let path = UIBezierPath()
        
        var chinY = faceRect.maxY
        if let faceContour = landmarks.faceContour {
            let contourPoints = faceContour.normalizedPoints.map {
                convertPoint($0, faceRect: faceRect)
            }
            if let lowestPoint = contourPoints.max(by: { $0.y < $1.y }) {
                chinY = lowestPoint.y
            }
        }
        
        let foreheadExtension = faceRect.height * 0.3
        let lineLength = (chinY - faceRect.minY) + foreheadExtension
        
        let verticalAngle = faceAngle + .pi / 2
        
        let halfLength = lineLength / 2
        let topX = midpoint.x - halfLength * cos(verticalAngle)
        let topY = midpoint.y - halfLength * sin(verticalAngle)
        let bottomX = midpoint.x + halfLength * cos(verticalAngle)
        let bottomY = midpoint.y + halfLength * sin(verticalAngle)
        
        path.move(to: CGPoint(x: topX, y: topY))
        path.addLine(to: CGPoint(x: bottomX, y: bottomY))
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.cyan.cgColor
        lineLayer.lineWidth = 2.5
        lineLayer.lineCap = .round
        lineLayer.name = "step1_vertical"
        
        overlayView.layer.addSublayer(lineLayer)
    }
    
    func drawIntersectionPoint(at point: CGPoint) {
        let circleRadius: CGFloat = 4
        
        let circlePath = UIBezierPath(
            arcCenter: point,
            radius: circleRadius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.systemOrange.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 1.5
        circleLayer.name = "step1_center"
        
        overlayView.layer.addSublayer(circleLayer)
    }
    
    // MARK: - Helper Functions
    
    func addStepLabel(text: String, at position: CGPoint) {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.fontSize = 18
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        textLayer.alignmentMode = .center
        textLayer.cornerRadius = 8
        textLayer.name = "step_label"
        
        let labelWidth: CGFloat = 300
        let labelHeight: CGFloat = 40
        textLayer.frame = CGRect(
            x: position.x - labelWidth / 2,
            y: position.y - labelHeight / 2,
            width: labelWidth,
            height: labelHeight
        )
        
        // Center text vertically
        textLayer.contentsScale = UIScreen.main.scale
        
        overlayView.layer.addSublayer(textLayer)
    }
    
    func calculateCenter(of points: [CGPoint]) -> CGPoint {
        guard !points.isEmpty else { return .zero }
        
        let sumX = points.reduce(0) { $0 + $1.x }
        let sumY = points.reduce(0) { $0 + $1.y }
        
        return CGPoint(
            x: sumX / CGFloat(points.count),
            y: sumY / CGFloat(points.count)
        )
    }
    
    func calculateFaceRect(face: VNFaceObservation, imageFrame: CGRect) -> CGRect {
        return CGRect(
            x: face.boundingBox.origin.x * imageFrame.width + imageFrame.origin.x,
            y: (1 - face.boundingBox.origin.y - face.boundingBox.height) * imageFrame.height + imageFrame.origin.y,
            width: face.boundingBox.width * imageFrame.width,
            height: face.boundingBox.height * imageFrame.height
        )
    }
    
    func imageFrameInImageView() -> CGRect {
        guard let image = imageView.image else { return .zero }
        
        let imageRatio = image.size.width / image.size.height
        let viewRatio = imageView.bounds.width / imageView.bounds.height
        
        if imageRatio > viewRatio {
            let width = imageView.bounds.width
            let height = width / imageRatio
            let y = (imageView.bounds.height - height) / 2
            return CGRect(x: 0, y: y, width: width, height: height)
        } else {
            let height = imageView.bounds.height
            let width = height * imageRatio
            let x = (imageView.bounds.width - width) / 2
            return CGRect(x: x, y: 0, width: width, height: height)
        }
    }
    
    func convertPoint(_ point: CGPoint, faceRect: CGRect) -> CGPoint {
        return CGPoint(
            x: faceRect.origin.x + point.x * faceRect.width,
            y: faceRect.origin.y + (1 - point.y) * faceRect.height
        )
    }
    func drawJawline(for face: VNFaceObservation) {
        guard let contour = face.landmarks?.faceContour else { return }

        let points = contour.normalizedPoints.map {
            convertPoint($0, faceRect: faceRect)
        }

        guard let first = points.first else { return }

        let path = UIBezierPath()
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }

        let jawLayer = CAShapeLayer()
        jawLayer.path = path.cgPath
        jawLayer.strokeColor = UIColor.white.cgColor
        jawLayer.fillColor = UIColor.clear.cgColor
        jawLayer.lineWidth = 3.0
        jawLayer.lineCap = .round
        jawLayer.lineJoin = .round
        jawLayer.name = "jawline"

        overlayView.layer.addSublayer(jawLayer)
    }
}

// MARK: - Picker Delegate

extension ViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        guard
            let provider = results.first?.itemProvider,
            provider.canLoadObject(ofClass: UIImage.self)
        else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                guard let self, let img = image as? UIImage else { return }

                // 1️⃣ Set image
                self.imageView.image = img
                self.imageView.layoutIfNeeded()

                // 2️⃣ Align boundary overlay (CRITICAL)
                self.outlineImageView.frame = self.imageFrameInImageView(self.imageView)
                self.outlineImageView.image = nil

                // 3️⃣ CLEAR previous cross
                self.overlayView.layer.sublayers?.removeAll()

                // 4️⃣ RUN BOTH PIPELINES
                self.processImage(img)      // 🔸 FACE BOUNDARY
                self.detectFace(in: img)    // 🔹 CROSS
            }
        }
    }
}
extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}

