//
//  ViewController.swift
//  ClipToBox
//
//  Created by SDC-USER on 01/08/25.
//gcr ->

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var parentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let child = UIView(frame: CGRect(x: -10, y: -10, width: 100, height: 100))
        child.backgroundColor = .red
        parentView.addSubview(child)
    }

    @IBAction func toggleButton(_ sender: UIButton) {
        parentView.clipsToBounds.toggle()       //mutating funcion(BOOL)
        sender.setTitle(parentView.clipsToBounds ? "Disable" : "Enable", for: .normal)     //state of the button
    }
    
}

