//
//  BMI.swift
//  BMIandAGE
//
//  Created by SDC-USER on 05/09/25.
//

import UIKit

class BMI: UIViewController {
    var result: String?
    @IBOutlet weak var BMI: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let BMI1 = Double(result ?? " ")!
        BMI.text = "\n"
        if(BMI1 < 18.5) {
            BMI.text = "\(BMI1) \n You are Underweight"
            view.backgroundColor = UIColor.red
        }
        else if(BMI1 > 18.5 && BMI1 < 25.0) {
            BMI.text = "\(BMI1) \n You are perfect"
            view.backgroundColor = UIColor.green
        }
        else {
            BMI.text = "\(BMI1) \n You are overweight"
            view.backgroundColor = UIColor.red
            
        }

        
    }
    


}
