//
//  ViewController.swift
//  billAndSplit
//
//  Created by SDC-USER on 05/08/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var totalPeople: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var tipPercent: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var splitAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    var bill: Double = 0
    var tip = 0
    var people = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tipSlider(_ sender: UISlider) {
        tip = Int(sender.value)
        tipPercent.text = "Tip: \(tip)%"
        
        let percent = bill * Double(tip) / 100.0
        tipLabel.text = String(format: "%.2f", percent)
        totalAmountLabel.text = String(format: "%.2f", (bill + percent))
        
    }

    
    @IBAction func totalAmount(_ sender: UITextField) {
        bill = Double(sender.text ?? "") ?? 00.00
    }
    
    @IBAction func stepperPeople(_ sender: UIStepper) {
        people = Int(sender.value)
        totalPeople.text = "People: \(people)"
        let str1 = bill / Double(people) + Double(tip / people) * 10
        splitAmount.text = String(format: "%.2f", str1)
    }
    
}

