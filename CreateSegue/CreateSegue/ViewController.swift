//
//  ViewController.swift
//  CreateSegue
//
//  Created by SDC-USER on 03/09/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var switchGo: UISwitch!
    
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goToRed(_ sender: Any) {
        if switchGo.isOn {
            performSegue(withIdentifier: "red", sender: nil)
            
        }
    }
    
    @IBAction func goToYellow(_ sender: Any) {
        if switchGo.isOn {
            performSegue(withIdentifier: "yellow", sender: nil)
        }
    }
    
    @IBAction func goTo(_ sender: Any) {
        if switchGo.isOn {
            performSegue(withIdentifier: textField.text ?? " ", sender: nil)
        }
    }
    
}
