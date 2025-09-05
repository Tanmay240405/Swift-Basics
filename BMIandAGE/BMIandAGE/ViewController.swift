//
//  ViewController.swift
//  BMIandAGE
//
//  Created by SDC-USER on 05/09/25.
//

import UIKit

class ViewController: UIViewController {
    var formatted: String?
    @IBOutlet weak var BMIlabel: UILabel!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var wieghtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calculateB(_ sender: Any) {
        
        performSegue(withIdentifier: "BMI", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let weight: String? = (wieghtField.text)
        let height: String? = (heightField.text)
        let wInt = Double(weight ?? "0")!
        let hInt = Double(height ?? "0")!
        let BMI = wInt / (hInt * hInt)
        formatted = String(format: "%.2f", BMI)
        
        if let resultVC = segue.destination as? BMI {
            resultVC.result = formatted
        }
    }
    
    
}

