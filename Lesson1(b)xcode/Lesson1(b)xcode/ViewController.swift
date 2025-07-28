//
//  ViewController.swift
//  Lesson1(b)xcode
//
//  Created by SDC-USER on 28/07/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelButton: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func happyButton(_ sender: Any) {
        labelButton.text = "😂"
    }
    @IBAction func sadButton(_ sender: Any) {
        labelButton.text = "😢"
    }
    @IBAction func angryButton(_ sender: Any) {
        labelButton.text = "😡"
    }
}

