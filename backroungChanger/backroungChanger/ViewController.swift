//
//  ViewController.swift
//  backroungChanger
//
//  Created by SDC-USER on 04/08/25.
//

import UIKit

class ViewController: UIViewController {
    var red : CGFloat = 0
    var Green : CGFloat  = 0
    var Blue : CGFloat = 0
    @IBOutlet weak var RedSlider: UISlider!
    
    @IBOutlet weak var greenSlider: UISlider!
    
    @IBOutlet weak var blueSlider: UISlider!
    
    override func viewDidLoad() {
        RedSlider.isEnabled = false
        greenSlider.isEnabled = false
        blueSlider.isEnabled = false
        super.viewDidLoad()
        
    }
    
    
    @IBAction func SliderValue(_ sender: UISlider) {
        red = CGFloat(RedSlider.value)
        Blue = CGFloat(blueSlider.value)
        Green = CGFloat(greenSlider.value)
        view.backgroundColor = UIColor(red: red, green: Green, blue: Blue, alpha: 1)
        
    }
    
    @IBAction func redSwitch(_ sender: UISwitch) {
        RedSlider.isEnabled = sender.isOn
        if sender.isOn == false {
            RedSlider.value = 0
            red = 0
            view.backgroundColor = UIColor(red: 0, green: Green, blue: Blue, alpha: 1)
        }
    }
    
    @IBAction func blueSwitch(_ sender: UISwitch) {
        blueSlider.isEnabled = sender.isOn
        if sender.isOn == false {
            blueSlider.value = 0
            Blue = 0
            view.backgroundColor = UIColor(red: red, green: Green, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func greeSwitch(_ sender: UISwitch) {
        greenSlider.isEnabled = sender.isOn
        if sender.isOn == false {
            greenSlider.value = 0
            Green = 0
            view.backgroundColor = UIColor(red: red, green: 0, blue: Blue, alpha: 1)
        }
    }
    
}

