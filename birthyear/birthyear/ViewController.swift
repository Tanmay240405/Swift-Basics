//
//  ViewController.swift
//  birthyear
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit
func dateTimeFormat(from date: Date) -> (Int) {
    let calender = Calendar.current
    let components = calender.dateComponents([.year], from: date)
    return (
        components.year ?? 0
       
    )
}

class ViewController: UIViewController {

    @IBOutlet weak var enterage: UILabel!
    @IBOutlet weak var printLabel: UILabel!
    @IBOutlet weak var enterYear: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func calcButton(_ sender: Any) {
        let date = Date()
        let year = dateTimeFormat(from: date)
        let num = Int(enterYear.text ?? "") ?? 0
        if num == 0 || num > year{
            printLabel.text = "Invalid"
        }
        else{
            let age = year - num
            printLabel.text = String(age)
        }
    }
    
}

