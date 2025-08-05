//
//  ViewController.swift
//  Greetingscustomize
//
//  Created by SDC-USER on 04/08/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fontSlider: UISlider!
    var Size: CGFloat = 0
    @IBOutlet weak var nameLabel1: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var colourSegment: UISegmentedControl!
    @IBOutlet weak var MrMrsSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel1.text = "Hello"
        nameLabel1.textColor = .red
       
    }

    @IBAction func nameSlider1(_ sender: UISlider) {
        Size = CGFloat(fontSlider.value) * 50
        nameLabel1.font = UIFont.systemFont(ofSize: Size)
    }
    
    
    @IBAction func greetButton(_ sender: UIButton) {
        let gender = MrMrsSegment.selectedSegmentIndex == 0 ? "Mr." : "Ms."
        nameLabel1.text = "Hello \(gender) \(nameField.text ?? "")"
        
        
    }
    
    @IBAction func genderSegment(_ sender: UISegmentedControl) {
        let gender1 = MrMrsSegment.selectedSegmentIndex
        if gender1 == 0 {
            nameLabel1.text = "Hello Mr. \(nameField.text ?? "")"
        }
        else if gender1 == 1 {
            nameLabel1.text = "Hello Ms. \(nameField.text ?? "")"
        }
       
    }
    
    
    @IBAction func colourSegment(_ sender: UISegmentedControl) {
        let colour = colourSegment.selectedSegmentIndex
        if colour == 0 {
            nameLabel1.textColor = .red
        }
        else if colour == 1 {
            nameLabel1.textColor = .green
        }
        else if colour == 2 {
            nameLabel1.textColor = .blue
        }
        else if colour == 3 {
            nameLabel1.textColor = .black
        }
    }
    
    @IBAction func resetButton(_ sender: Any) {
        nameLabel1.text = "Hello"
    }
    
    
    
}

