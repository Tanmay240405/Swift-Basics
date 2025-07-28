//
//  ViewController.swift
//  Lesson1(c)xcode
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var enterNum: UITextField!
    @IBOutlet weak var greetLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPrint(_ sender: Any) {
        if let num = Int(enterNum.text!) {
            if  num % 2 == 0 {
                printLabel.text = "EVEN"
            }
            else{
                printLabel.text = "ODD"
            }
        } else {
            printLabel.text = "Invalid"
        }
    }
    
}

