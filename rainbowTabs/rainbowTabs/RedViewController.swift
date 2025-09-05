//
//  ViewController.swift
//  rainbowTabs
//
//  Created by SDC-USER on 05/09/25.
//

import UIKit

class RedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarItem.badgeValue = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarItem.badgeValue = "!"
    }


}

