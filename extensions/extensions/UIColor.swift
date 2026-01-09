//
//  UIColor.swift
//  extensions
//
//  Created by SDC-USER on 09/01/26.
//

import Foundation
import UIKit

extension UIColor {                                                        //changing properties of a pre defined class UIColor
    static var random: UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}


//not same as inheritance
//sub class cannot override functions written in parent class
//conforming to a protocol in an extension




