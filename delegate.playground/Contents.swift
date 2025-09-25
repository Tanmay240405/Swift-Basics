import UIKit

var greeting = "Hello, playground"

protocol messenger {
    func passData(_ data: String)
}

class FirstView_reciever: messenger {
    func passData(_ data: String) {
        print("data recieved is \(data)")
    }
    
    
}

class SecondView_sender {
    var delegate: messenger?
    func sendData(_ data: String){
        delegate?.passData(data)
    }
    
}

var firstView = FirstView_reciever()
var secondView = SecondView_sender()
secondView.delegate = firstView

secondView.sendData("Hello World")



protocol ramukaka {
    func passData(_ data: String)
}

class Sender {
    var delegate: ramukaka?
    func sendData(_ data: String) {
        self.delegate?.passData(data)
    }
}
class receiver: ramukaka {
    func passData(_ data: String) {
        print("Shyam has recieved \(data)")
    }
}

var ram = Sender()
var shyam = receiver()
ram.delegate = shyam
ram.sendData("email")

