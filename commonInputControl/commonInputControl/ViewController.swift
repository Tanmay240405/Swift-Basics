//
//  ViewController.swift
//  commonInputControl
//
//  Created by SDC-USER on 04/08/25.
//

import UIKit


class ViewController: UIViewController {
    var count = 0
    @IBOutlet weak var printLabel: UILabel!
    override func viewDidLoad() {
        printLabel.text = "o"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ButtonClick(_ sender: Any) {
        count += 1
        printLabel.text = "\(count)"
    }
    
    @IBAction func decrease(_ sender: Any) {
        count -= 1
        printLabel.text = "\(count)"
    }
    
    @IBAction func SwitchButton(_ sender: UISwitch) {
        printLabel.text = sender.isOn ? "On" : "Off"
    }
    
    @IBAction func slider(_ sender: UISlider) {
        printLabel.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func textField(_ sender: UITextField) {
        
    }
    
    
    @IBAction func tabGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        print(location)
        let dot = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        dot.backgroundColor = .red
        dot.layer.cornerRadius = 5
        dot.center = location
        view.addSubview(dot)
        
    }
    
}

