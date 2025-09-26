//
//  ViewController2.swift
//  delegates
//
//  Created by SDC-USER on 26/09/25.
//

import UIKit

class ViewController2: UIViewController {
    var delegate: passData?

    @IBOutlet weak var input: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        delegate?.receivedata(data: input.text ?? "No Data Provided")
        dismiss(animated: true)
    }
    


}
