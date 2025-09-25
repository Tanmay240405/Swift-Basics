import UIKit
import Foundation
var greeting = "Hello, playground"

class Student:CustomStringConvertible,Comparable {                     // adapting
    static func < (lhs: Student, rhs: Student) -> Bool {
        return lhs.rollNo < rhs.rollNo
    }
    
    static func == (lhs: Student, rhs: Student) -> Bool {
        return lhs.rollNo == rhs.rollNo && lhs.firstName == rhs.firstName && lhs.lastname == rhs.lastname
    }

    var description: String {return "name of the student is \(firstName) \(lastname)"}        //computed property----------> stub ----------------> conforming
    
    let rollNo: Int
    let firstName: String
    let lastname: String
    init(rollNo: Int, firstName: String, lastname: String) {
        self.rollNo = rollNo
        self.firstName = firstName
        self.lastname = lastname
    }
}

var student1 = Student(rollNo: 1, firstName: "Tanmay", lastname: "Saxena")
var student2 = Student(rollNo: 2, firstName: "tgt", lastname: "Seertgrtg")

print(student1)
if student1 === student2 {
    print("thye are equal")
}


class Shoe:CustomStringConvertible {
    var description: String {return "my shoe is of size \(size) and \(brand) brand "}
    
    let size: Int
    let brand: String
    let colour: String
    init(size: Int, brand: String, colour: String) {
        self.size = size
        self.brand = brand
        self.colour = colour
    }
}

var myShoe = Shoe(size: 7, brand: "a", colour: "red")
print(myShoe)


class myData {
    let name: String
    let age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}



class iosSDP: Codable {
    var institute: String
    var name: String
    var year: Int
    init(institute: String, name: String, year: Int) {
        self.institute = institute
        self.name = name
        self.year = year
    }
}
var mitSDP = iosSDP(institute: "MITWPU", name: "Tanmay", year: 2025)

var jsonEncoder = JSONEncoder()
if let data = try?jsonEncoder.encode(mitSDP){
    if let jsonString = String(data: data, encoding: .utf8){
        print(jsonString)
    }
}
