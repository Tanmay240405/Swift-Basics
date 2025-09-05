//
//  ViewController.swift
//  passingData2
//
//  Created by SDC-USER on 03/09/25.
//

import UIKit

class ViewController: UIViewController {
    var data :String?
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "BMI", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        data = textField.text
        if let resultVC = segue.destination as? SecondViewController {
            resultVC.result = data
        }
    }
    
}

