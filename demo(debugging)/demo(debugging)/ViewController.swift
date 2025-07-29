//  ViewController.swift
//  demo(debugging)
//
//  Created by SDC-USER on 29/07/25.
// error, bug and warning
// cannot compile with error
//

import UIKit

class ViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        let a = 10
        var array: [Int] = [10, 20, 30]
        array.removeFirst()
        array.removeFirst()
        array.removeFirst()
        array.removeFirst() //no error but a bug(affects functionality of the code)

        // Do any additional setup after loading the view.
    }


}

