//
//  ViewController.swift
//  birthyear
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var enterage: UILabel!
    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var enterYear: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func calcButton(_ sender: Any) {
        let num = Int(enterYear.text ?? "") ?? 0
        if num == 0 || num > 2025{
            printLabel.text = "Invalid"
        }
        else{
            let age = 2025 - num
            printLabel.text = String(age)
        }
    }
    
}

