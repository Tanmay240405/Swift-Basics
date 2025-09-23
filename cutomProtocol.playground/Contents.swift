import UIKit

var greeting = "Hello, playground"

protocol Fullyname {
    var fullName: String { get }

    func sayFullName()
}

struct Person: Fullyname {
    var fullName: String
    
    func sayFullName() {
        
    }
    
    var firstName: String
    var lastName: String
}
