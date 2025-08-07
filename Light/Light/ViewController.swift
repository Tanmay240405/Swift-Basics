//
//  ViewController.swift
//  Light
//
//  Created by SDC-USER on 07/08/25.
//

import UIKit

class ViewController: UIViewController {
    
    var lightOn = true

    @IBOutlet var lightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }

    fileprivate func updateUI() {
        if lightOn {
            view.backgroundColor = .white
            
        }
        else {
            view.backgroundColor = .black
           
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        lightOn.toggle()
        updateUI()
    }
    
}

