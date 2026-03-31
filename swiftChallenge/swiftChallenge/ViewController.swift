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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false
    }
    
    @IBAction func pickImageTapped(_ sender: UIButton) {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
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
                
                // After 1 second, draw Step 2: Face Outline
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.drawStep2FaceOutline(for: face)
                }
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
        
        // Add step label
        addStepLabel(text: "Step 1: Guide Cross", at: CGPoint(x: imageFrame.midX, y: imageFrame.maxY - 50))
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
    
    // MARK: - STEP 2: Animated Face Outline (Using Landmarks)
    
    func drawStep2FaceOutline(for face: VNFaceObservation) {
        // Remove step 1 label
        overlayView.layer.sublayers?.forEach { layer in
            if layer.name == "step_label" {
                layer.removeFromSuperlayer()
            }
        }
        
        guard let landmarks = face.landmarks else { return }
        
        // Create complete face outline path from landmarks
        let completePath = UIBezierPath()
        
        // 1. Face Contour (jawline and sides)
        if let faceContour = landmarks.faceContour {
            let points = faceContour.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
            }
        }
        
        // 2. Left Eyebrow
        if let leftEyebrow = landmarks.leftEyebrow {
            let points = leftEyebrow.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
            }
        }
        
        // 3. Right Eyebrow
        if let rightEyebrow = landmarks.rightEyebrow {
            let points = rightEyebrow.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
            }
        }
        
        // 4. Left Eye
        if let leftEye = landmarks.leftEye {
            let points = leftEye.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
                completePath.close()
            }
        }
        
        // 5. Right Eye
        if let rightEye = landmarks.rightEye {
            let points = rightEye.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
                completePath.close()
            }
        }
        
        // 6. Nose
        if let nose = landmarks.nose {
            let points = nose.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
            }
        }
        
        // 7. Nose Crest
        if let noseCrest = landmarks.noseCrest {
            let points = noseCrest.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
            }
        }
        
        // 8. Outer Lips
        if let outerLips = landmarks.outerLips {
            let points = outerLips.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
                completePath.close()
            }
        }
        
        // 9. Inner Lips
        if let innerLips = landmarks.innerLips {
            let points = innerLips.normalizedPoints.map { convertPoint($0, faceRect: faceRect) }
            if let first = points.first {
                completePath.move(to: first)
                for point in points.dropFirst() {
                    completePath.addLine(to: point)
                }
                completePath.close()
            }
        }
        
        // Add forehead outline (extended from eyebrows)
        addForeheadOutline(to: completePath, landmarks: landmarks)
        completePath.close()
        
        // Create the shape layer
        let outlineLayer = CAShapeLayer()
        outlineLayer.path = completePath.cgPath
        outlineLayer.strokeColor = UIColor.white.cgColor
        outlineLayer.fillColor = UIColor.clear.cgColor
        outlineLayer.lineWidth = 3.0
        outlineLayer.lineCap = .round
        outlineLayer.lineJoin = .round
        outlineLayer.name = "step2_outline"
        
        // Animate the stroke
        outlineLayer.strokeEnd = 0
        
        overlayView.layer.addSublayer(outlineLayer)
        
        // Animate drawing the outline
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 1
        drawAnimation.duration = 3.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        drawAnimation.fillMode = .forwards
        drawAnimation.isRemovedOnCompletion = false
        
        outlineLayer.add(drawAnimation, forKey: "drawOutline")
        outlineLayer.strokeEnd = 1
        
        // Add step 2 label
        addStepLabel(text: "Step 2: Face Outline - Sketch this!", at: CGPoint(x: imageFrame.midX, y: imageFrame.maxY - 50))
        
        // Optional: Add semi-transparent fill
        addFaceShading(landmarks: landmarks)
    }
    
    func addForeheadOutline(to path: UIBezierPath, landmarks: VNFaceLandmarks2D) {
        guard
            let leftEyebrow = landmarks.leftEyebrow,
            let rightEyebrow = landmarks.rightEyebrow,
            let faceContour = landmarks.faceContour
        else { return }

        let leftBrowPoints = leftEyebrow.normalizedPoints.map {
            convertPoint($0, faceRect: faceRect)
        }
        let rightBrowPoints = rightEyebrow.normalizedPoints.map {
            convertPoint($0, faceRect: faceRect)
        }
        let contourPoints = faceContour.normalizedPoints.map {
            convertPoint($0, faceRect: faceRect)
        }

        // Brow highest points
        guard
            let leftBrowTop = leftBrowPoints.min(by: { $0.y < $1.y }),
            let rightBrowTop = rightBrowPoints.min(by: { $0.y < $1.y }),
            let leftTemple = contourPoints.first,
            let rightTemple = contourPoints.last
        else { return }

        // Forehead height estimation
        let browY = min(leftBrowTop.y, rightBrowTop.y)
        let foreheadHeight = faceRect.height * 0.28
        let foreheadTopY = browY - foreheadHeight

        // Forehead curve control points
        let topCenter = CGPoint(x: faceRect.midX, y: foreheadTopY)

        let cpLeft = CGPoint(
            x: faceRect.midX - faceRect.width * 0.45,
            y: foreheadTopY - faceRect.height * 0.05
        )

        let cpRight = CGPoint(
            x: faceRect.midX + faceRect.width * 0.45,
            y: foreheadTopY - faceRect.height * 0.05
        )

        // Draw smooth forehead arc
        path.addQuadCurve(to: topCenter, controlPoint: cpLeft)
        path.addQuadCurve(to: rightTemple, controlPoint: cpRight)
    }
    
    func addFaceShading(landmarks: VNFaceLandmarks2D) {
        guard let faceContour = landmarks.faceContour else { return }
        
        let points = faceContour.normalizedPoints.map {
            convertPoint($0, faceRect: faceRect)
        }
        
        let shadePath = UIBezierPath()
        if let first = points.first {
            shadePath.move(to: first)
            for point in points.dropFirst() {
                shadePath.addLine(to: point)
            }
            shadePath.close()
        }
        
        let shadeLayer = CAShapeLayer()
        shadeLayer.path = shadePath.cgPath
        shadeLayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
        shadeLayer.name = "step2_shade"
        
        // Insert behind the outline
        if let outlineLayer = overlayView.layer.sublayers?.first(where: { $0.name == "step2_outline" }) {
            overlayView.layer.insertSublayer(shadeLayer, below: outlineLayer)
        } else {
            overlayView.layer.addSublayer(shadeLayer)
        }
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
}

// MARK: - Picker Delegate

extension ViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                if let img = image as? UIImage {
                    self?.imageView.image = img
                    self?.detectFace(in: img)
                }
            }
        }
    }
}
