//
//  ViewController.swift
//  scrollingAdvance
//
//  Created by SDC-USER on 26/09/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        
       
    }
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func KeyBoardWillShow(notification: Notification) {
        if let info = notification.userInfo,
           let keyBoardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyBoardFrame = keyBoardFrameValue.cgRectValue
            let keyBoardSize = keyBoardFrame.size
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardSize.height, right: 0)
            scrollView.contentInset = contentInsets
        }
    }
    @objc func KeyboardWillHide(notification: Notification) {
        let contentInset: UIEdgeInsets = .zero
        scrollView.contentInset = contentInset
        
    }

}

