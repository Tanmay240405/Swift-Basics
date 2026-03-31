//
//  ViewController.swift
//  challenge
//
//  Created by SDC-USER on 31/01/26.
//

import UIKit
import Vision
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    let outlineImageView = UIImageView()

        override func viewDidLoad() {
            super.viewDidLoad()
            setupOverlay()
        }
        
    func setupOverlay() {
        outlineImageView.backgroundColor = .clear
        outlineImageView.contentMode = .scaleToFill
        outlineImageView.isUserInteractionEnabled = false
        imageView.addSubview(outlineImageView)
    }
        @IBAction func pickImageTapped(_ sender: UIButton) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
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
    }

    // Helper to convert UIImage orientation to Vision orientation
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

