//
//  ViewController.swift
//  delegates
//
//  Created by SDC-USER on 26/09/25.
//

import UIKit
protocol passData {
    func receivedata(data: String)
}


class ViewController: UIViewController, passData {
    @IBOutlet weak var myLabel: UILabel!
    func receivedata(data: String) {
        myLabel.text = "Received data is - \(data)"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController2{
            destination.delegate = self
        }
    }

}

