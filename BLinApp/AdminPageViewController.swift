//
//  AdminPageViewController.swift
//  BLinApp
//
//  Created by kito on 11/6/17.
//  Copyright © 2017 kito. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore


class AdminPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!
    var dataArray = [String]()
    var listArray = [String]()
    
    @IBOutlet weak var dataTable: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var pickTheDate: UIDatePicker!
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        refreshTableWithData()
    }
 
    func getTheDate() -> (dateYear: String, dateMonth: String, dateDay: String){
        let displayDate = DateFormatter()
        displayDate.dateFormat = "MM/dd/yyyy"
       
        let dateSchedule = displayDate.string(from: pickTheDate.date)
        
        // get day of the date
        let endIndexMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-8)
        let indexMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-10)
        let dateOfMonth = dateSchedule[indexMonth ..< endIndexMonth]
        
        //get Month of the date
        let indexDay = dateSchedule.index(dateSchedule
            .startIndex, offsetBy: 3)
        let endIndexDay = dateSchedule.index(dateSchedule.endIndex, offsetBy:-5)
        let dateOfDay =  dateSchedule[indexDay ..< endIndexDay]
        
        //getYear of the date
        let endIndexDateOfYear = dateSchedule.index(dateSchedule.endIndex, offsetBy:0)
        let indexDateOfYear = dateSchedule.index(dateSchedule.endIndex, offsetBy:-4)
        let dateOfYear = dateSchedule[indexDateOfYear ..< endIndexDateOfYear]
        let year = String(dateOfYear)
        let month = String(dateOfMonth)
        let day = String(dateOfDay)
        
        return (year, month, day)
    }
    
    
    func refreshTableWithData() {
      
        
        ref = Database.database().reference()
        var stringToAppend = " "
        ref.child(getTheDate().dateYear).child(getTheDate().dateMonth).child(getTheDate().dateDay).observeSingleEvent(of: .value, with: { snapshot in
            self.listArray.removeAll()
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let enumerator = rest.children
                while let rest1 = enumerator.nextObject() as? DataSnapshot {
                    if (rest1.key == "Phone Number"){
                        let phone = String(describing: rest1.value!)
                        self.listArray.append("PHONE NUMBER: " + phone)
                    }
                      else if (rest1.key == "Name") {
                        stringToAppend = String(describing: rest1.value!)
                    } else if (rest1.key == "Time") {
                        stringToAppend += "   TIME: "
                        stringToAppend += String(describing: rest1.value!)
                        self.listArray.append("NAME: " + stringToAppend)
                        self.listArray.append("     ")
                    } else {
                        self.listArray.append("Service: " + String(describing: rest1.value!))
                        
                    }
                }
            }
            self.dataArray = self.listArray
            self.dataTable.reloadData()
        })
        
    }
    @IBAction func selectTheDate(_ sender: Any) {
        self.refreshTableWithData()
       
    }
    
    @IBAction func refreshButton(_ sender: UIButton) {
        self.dataTable.reloadData()
       
     
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "dataCell")
        
       
            cell.textLabel?.text = self.dataArray[indexPath.row]

         return cell
      
    }
  
 
}
