//
//  ScheduleScreen.swift
//  BLinApp
//
//  Created by kito on 10/27/17.
//  Copyright © 2017 kito. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ScheduleScreen: UIViewController {

    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    var userExistAppointment = false
    var checkIfTrue = false
    
    
 
    //
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var selectService: UIButton!
    @IBOutlet weak var pickTheDate: UIDatePicker!
    
    @IBOutlet weak var pickTheTime: UILabel!
  
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    
    @IBOutlet weak var scheduleDisplay: UILabel!
    
    @IBOutlet weak var showService: UILabel!
    
    @IBOutlet weak var backgroundButton: UIButton!
    
    @IBOutlet weak var b9AM: UIButton!
    @IBOutlet weak var b10AM: UIButton!
    
    @IBOutlet weak var b11AM: UIButton!
    @IBOutlet weak var b12PM: UIButton!
    @IBOutlet weak var b1PM: UIButton!
    @IBOutlet weak var b2PM: UIButton!
    
    @IBOutlet weak var b3PM: UIButton!
    @IBOutlet weak var b4PM: UIButton!
    @IBOutlet weak var b5PM: UIButton!
    @IBOutlet weak var b6PM: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let displayDate = DateFormatter()
        displayDate.dateFormat = "MM/dd/yyyy"
        
        scheduleDisplay.text = displayDate.string(from: pickTheDate.date)
        
        self.selectService.layer.cornerRadius = 5
        self.popUpView.layer.cornerRadius = 10
        self.popUpView.layer.masksToBounds = true
        self.checkAvailbility()

    }
    
    @IBAction func ba9AM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba10AM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba11AM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba12AM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba1PM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba2PM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba3PM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba4PM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba5PM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    @IBAction func ba6PM(_ sender: UIButton) {
        pickTheTime.text = sender.currentTitle!
    }
    
    
    //check availability
    func checkSpecificAvail(time: String, completed: @escaping () -> Void){
        let dateSchedule = scheduleDisplay.text!
        
        var count = 0
        //get Date of the date
        let endIndexDateOfMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-8)
        let indexDateOfMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-10)
        let dateOfMonth = dateSchedule[indexDateOfMonth ..< endIndexDateOfMonth]
        
        //get Month of the date
        let indexMonth = dateSchedule.index(dateSchedule
            .startIndex, offsetBy: 3)
        let endIndexMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-5)
        let dateOfMonthMonth =  dateSchedule[indexMonth ..< endIndexMonth]
        
        //getYear of the date
        let endIndexDateOfYear = dateSchedule.index(dateSchedule.endIndex, offsetBy:0)
        let indexDateOfYear = dateSchedule.index(dateSchedule.endIndex, offsetBy:-4)
        let dateOfYear = dateSchedule[indexDateOfYear ..< endIndexDateOfYear]
        
        self.ref.child(String(dateOfYear)).child(String(dateOfMonth)).child(String(dateOfMonthMonth)).observeSingleEvent(of: .value, with: { snapshot in
            
            let enumerator = snapshot.children
            
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let enumerator = rest.children
                while let rest1 = enumerator.nextObject() as? DataSnapshot {
                    let actualValue = String (describing: rest1.value!)
                    if (rest1.key == "Time" && actualValue == time) {
                        count = count + 1
                        if (count == 4) {
                            print("no slot")
                            self.checkIfTrue = true
                            print(self.checkIfTrue)
                        }
                    }
                    
                }
            }
            completed()
        })
        
    }
    
    
    
  
    //check if date is already scheduled or if user alredy have an appointment
    @IBAction func confirmSchedule(_ sender: UIButton) {

        let dateSchedule = scheduleDisplay.text!
        let timeSchedule = pickTheTime.text!
        let fullname = fullName.text!
        let phonenumber = phoneNumber.text!
        var showTypOfService = showService.text!
        
        if (showTypOfService.isEmpty) {
            showTypOfService = " "
        }
        
        
        let whitespaceSet = CharacterSet.whitespaces
        
        //check if all required fields are empty
        if (timeSchedule.isEmpty || fullname.trimmingCharacters(in: whitespaceSet).isEmpty || phonenumber.trimmingCharacters(in: whitespaceSet).isEmpty) {
            let alert = UIAlertController(title: "Can't schedule an Appointment!", message: "Time, Name and Phone # maybe missing", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.destructive, handler: {
                action in
                
                self.dismiss(animated: true, completion: nil)
            }))
            
        }
        
        else {
        
        //get Date of the date
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
        
       
        ref.child("AllUserID").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var ifUserPresent = false
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let userID = self.user?.uid
               
                if (rest.key == userID) {
                   ifUserPresent = true
                }
            }
            
            // creating appointment
            if (ifUserPresent == false) {
                if let user = self.user {
                   
                    self.checkSpecificAvail(time: timeSchedule, completed: {
                        if (self.checkIfTrue == true) {
                            self.checkAvailbility()
                            self.checkIfTrue = false
                            let alert = UIAlertController(title: "Seems like this time is all booked HUMAN!", message: "Try again later! Or click on refresh button!", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.destructive, handler: {
                                action in
                                
                                self.dismiss(animated: true, completion: nil)
                            }))
                            
                            
                        } else {
                            print(self.checkIfTrue)
                            let userID = user.uid
                            self.ref.child(String(dateOfYear)).child(String(dateOfMonth)).child(String(dateOfDay)).child(userID).setValue(["Time" : timeSchedule, "Name" : fullname, "Phone Number" : phonenumber, "Service Type" : showTypOfService])
                            
                            
                            self.ref.child("AllUserID").child(userID).setValue(String(dateOfMonth) + " " + String(dateOfDay) + " " + String(dateOfYear))
                            let alert = UIAlertController(title: "Appointment Created!", message: "See you soon!", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.destructive, handler: {
                                action in
                                
                                self.dismiss(animated: true, completion: nil)
                            }))
                        }
                    })
                    
                }
            } else {
                let alert = UIAlertController(title: "Ooops, looks like you alredy have appoinment", message: "Please delete the old one to make new appointment", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.destructive, handler: {
                    action in
                    
                    self.dismiss(animated: true, completion: nil)
                }))
            }
            
        })
       
 
        
       
        }
    }
    
    
    func checkAvailbility() {
        let dateSchedule = scheduleDisplay.text!

        //get Date of the date
        let endIndexDateOfMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-8)
        let indexDateOfMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-10)
        let dateOfMonth = dateSchedule[indexDateOfMonth ..< endIndexDateOfMonth]
        
        //get Month of the date
        let indexMonth = dateSchedule.index(dateSchedule
            .startIndex, offsetBy: 3)
        let endIndexMonth = dateSchedule.index(dateSchedule.endIndex, offsetBy:-5)
        let dateOfMonthMonth =  dateSchedule[indexMonth ..< endIndexMonth]
        
        //getYear of the date
        let endIndexDateOfYear = dateSchedule.index(dateSchedule.endIndex, offsetBy:0)
        let indexDateOfYear = dateSchedule.index(dateSchedule.endIndex, offsetBy:-4)
        let dateOfYear = dateSchedule[indexDateOfYear ..< endIndexDateOfYear]
        
        
        
        ref.child(String(dateOfYear)).child(String(dateOfMonth)).child(String(dateOfMonthMonth)).observeSingleEvent(of: .value, with: { snapshot in
            if (snapshot.exists()) {
                
                self.ref.child(String(dateOfYear)).child(String(dateOfMonth)).child(String(dateOfMonthMonth)).observe(DataEventType.value, with: { snapshot in
                    // track count of appointment limit
                    var count9AM = 0
                    var count10AM = 0
                    var count11AM = 0
                    var count12PM = 0
                    var count1PM = 0
                    var count2PM = 0
                    var count3PM = 0
                    var count4PM = 0
                    var count5PM = 0
                    var count6PM = 0

                    let enumerator = snapshot.children
                    
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        let enumerator = rest.children
                        while let rest1 = enumerator.nextObject() as? DataSnapshot {
                            let actualValue = String (describing: rest1.value!)
                            
                            
                            
                            if (rest1.key == "Time" && actualValue == "09: 00 AM") {
                                count9AM = count9AM + 1
                                print(count9AM)
                                if (count9AM > 3) {
                                    self.b9AM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                    
                                    
                                } else {
                                 
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            }
                                
                            else if (rest1.key == "Time" && actualValue == "10: 00 AM") {
                                count10AM = count10AM + 1
                                if (count10AM > 3) {
                                    self.b10AM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "11: 00 AM") {
                                count11AM = count11AM + 1
                                if (count11AM > 3) {
                                    self.b11AM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "12: 00 PM") {
                                count12PM = count12PM + 1
                                if (count12PM > 3) {
                                    self.b12PM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "01: 00 PM") {
                                count1PM = count1PM + 1
                                if (count1PM > 3) {
                                    self.b1PM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "02: 00 PM") {
                                count2PM = count2PM + 1
                                if (count2PM > 3 ) {
                                    self.b2PM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "03: 00 PM") {
                                count3PM = count3PM + 1
                                if (count3PM > 3) {
                                    self.b3PM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "04: 00 PM") {
                                count4PM = count4PM + 1
                                if (count4PM > 3) {
                                    self.b4PM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "05: 00 PM") {
                                count5PM = count5PM + 1
                                if (count5PM > 3) {
                                    self.b5PM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            } else if (rest1.key == "Time" && actualValue == "06: 00 PM") {
                                count6PM = count6PM + 1
                                if (count6PM > 3) {
                                    self.b6PM.backgroundColor = UIColor.black
                                    self.b9AM.isEnabled = false
                                } else {
                                    self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                    
                })
            } else {
                self.b9AM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b10AM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b11AM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b12PM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b1PM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b2PM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b3PM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b4PM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b5PM.backgroundColor = UIColor(white: 1, alpha: 0)
                self.b6PM.backgroundColor = UIColor(white: 1, alpha: 0)
                
            }
            
            })
    }
    
   
    
    // Button to refresh the Availability of the Schedule on screen
    @IBAction func refreshAvailability(_ sender: UIButton) {
        
       self.checkAvailbility()
        
    }

    
    @IBAction func selectDate(_ : AnyObject) {
        let todaysDate = Date()
        pickTheDate.minimumDate = todaysDate
        
        let displayDate = DateFormatter()
        displayDate.dateFormat = "MM/dd/yyyy"
        
        scheduleDisplay.text = displayDate.string(from: pickTheDate.date)
         self.checkAvailbility()
        
    }


    @IBOutlet weak var centerPopConstraint: NSLayoutConstraint!
    
  
    @IBAction func closePopUp(_ sender: UIButton) {
        self.showService.text = "Pedicure"
        centerPopConstraint.constant = -600
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            
        })
        self.backgroundButton.alpha = 0
    }
    
    @IBAction func backgroundAction(_ sender: UIButton) {
        centerPopConstraint.constant = -600
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
        self.backgroundButton.alpha = 0
    }
    @IBAction func close(_ sender: UIButton) {
        self.showService.text = "Manicure"
        centerPopConstraint.constant = -600
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
        self.backgroundButton.alpha = 0
    }
    
    
    @IBAction func selectService(_ sender: UIButton) {
        centerPopConstraint.constant = 0
        UIView.animate(withDuration: 0.9, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
        })
        
    }
    
   
   
    
   
  
    
}
