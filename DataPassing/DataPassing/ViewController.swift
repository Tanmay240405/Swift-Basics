//
//  ViewController.swift
//  DataPassing
//
//  Created by SDC-USER on 03/09/25.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var textFieldData: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.navigationItem.title = textFieldData.text
    }

    
    
}

