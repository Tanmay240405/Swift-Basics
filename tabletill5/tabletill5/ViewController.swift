//
//  ViewController.swift
//  tabletill5
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var l1: UILabel!
    @IBOutlet weak var enternum: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcButton(_ sender: Any) {
        let num = Int(enternum.text ?? "") ?? 0
        if num == 0{
            l1.text = "Invalid"
        }
        else{
            var string1 = ""
            for index in 1...10{
                string1 += "\(num) X \(index) = \(index * num) \n"
                
            }
            l1.text = string1
            
        }
    }
    
}


