//
//  ViewController.swift
//  factorial
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var enterNum: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcButton(_ sender: Any) {
        let num = Int(enterNum.text ?? "") ?? -1
        var fact = 1
        if num == -1{
            printLabel.text = "invalid"
        }
        else if num == 0{
            printLabel.text = "1"
        }
        else{
            for i in 1...num{
                fact = fact * i
            }
            printLabel.text = String(fact)
  
           
        }
        
    }
    
}

