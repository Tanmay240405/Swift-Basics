import UIKit
// Calcu
func calculateArea(length: Double, width: Double) -> Double {
        length * width
}

print(calculateArea(length: 10.0, width: 12.0))

func reverse(st1: String) -> String {
    return String(st1.reversed())
}

print(reverse(st1: "Tanmay"))

func fact(num: Int) -> Int{
    if num == 0{
        return 1
    }
    return  num * (fact(num: num - 1))
}

print(fact(num: 4))

func swapValue (a: inout Int, b: inout Int) {
    var temp: Int
    temp = a
    a = b
    b = temp
}

func palindrome(str1: String) -> Bool {
    let arr1 = Array(str1)
    let size = str1.count - 1
    for i in 0...size {
        if arr1[i] != arr1[size - i] {
            return false
        }
    }
    return true
    
}

print(palindrome(str1: "anna"))


func count (str1: String) -> Int {
    var count = 0
    let str2 = str1.lowercased()
    for i in str2{
        if i == "a" || i == "e" || i == "i" || i == "o" || i == "u" {
            count += 1
        }
    }
    return count
}

let q = count(str1: "Tanmay")
print(q)

func power (base: Int, power1: Int) -> Int {
    var a = base
    var b = power1
    if b == 1{
        return a
    }
    return a * (power (base: a, power1: b-1))
}


print(power(base: 2, power1: 3))


