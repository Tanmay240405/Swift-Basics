//  ViewController.swift
//  Lesson1(a)xcode
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit

class ViewController:
    UIViewController {

    @IBOutlet weak var printField: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func greetButton(_ sender: Any) {
        printField.text = "Hello " + nameField.text!  //optional unwrapping
    }
    
}

