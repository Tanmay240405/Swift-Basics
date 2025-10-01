//
//  ViewController.swift
//  tableView2
//
//  Created by SDC-USER on 30/09/25.
//

import UIKit

import UIKit

struct Data {
    var Rollno: String
    var name: String
    var age: String
    var major: String
}

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var students: [Data] = [
        Data(Rollno: "10", name: "Tanmaye", age: "20", major: "CS"),
        Data(Rollno: "20", name: "Tanmay", age: "21", major: "CSE"),
        Data(Rollno: "30", name: "Tanmaysdv", age: "22", major: "ECE"),
        Data(Rollno: "40", name: "Tanmay", age: "23", major: "MECH")
    ]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let student = students[indexPath.row]
        
        cell.textLabel?.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)

        cell.textLabel?.text = String(
            format: "%-10d %-15s %-5d %-10s",
            student.Rollno,
            (student.name as NSString).utf8String!,
            student.age,
            (student.major as NSString).utf8String!
        )
        
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        //no need to register ----> no need to add subview if we drag it from library
    }


}

