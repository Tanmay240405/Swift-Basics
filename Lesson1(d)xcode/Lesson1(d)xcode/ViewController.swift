//
//  ViewController.swift
//  Lesson1(d)xcode
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var printlabel2: UILabel!
    @IBOutlet weak var entert2: UITextField!
    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var enterTemp: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcButton(_ sender: Any) {
        let num: Double = Double(enterTemp.text ?? "") ?? 0
        let temp: Double = (num * 9 / 5) + 32
        printLabel.text = String(temp)
    }
    
    @IBAction func calcb2(_ sender: Any) {
        let num1: Double = Double(entert2.text ?? "") ?? 0
        let temp1: Double = ((num1 - 32.0) * 5.0 / 9.0)
        printlabel2.text = String(temp1)
    }
}

