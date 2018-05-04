//
//  MainScreenViewController.swift
//  BLinApp
//
//  Created by kito on 10/19/17.
//  Copyright © 2017 kito. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import UserNotifications

class MainScreenViewController: UIViewController {
      var ref: DatabaseReference!
      let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        showUserAppointment()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref = Database.database().reference()
        showUserAppointment()
    }
   
  

    @IBOutlet weak var appointmentDate: UILabel!
    
    @IBOutlet weak var appointmentTime: UILabel!
    
    @IBOutlet weak var displayText: UITextField!
    
    @IBOutlet weak var name: UILabel!
    
    
    
    //divide date into year, month and date
    func divideDate(dateString: String) -> (y: String, m: String, d: String) {
        //get Date of the date
        let endIndexMonth = dateString.index(dateString.endIndex, offsetBy:-8)
        let indexMonth = dateString.index(dateString.endIndex, offsetBy:-10)
        let dateOfMonth = dateString[indexMonth ..< endIndexMonth]
        
        //get Month of the date
        let indexDay = dateString.index(dateString
            .startIndex, offsetBy: 3)
        let endIndexDay = dateString.index(dateString.endIndex, offsetBy:-5)
        let dateOfDay =  dateString[indexDay ..< endIndexDay]
        
        //getYear of the date
        let endIndexDateOfYear = dateString.index(dateString.endIndex, offsetBy:0)
        let indexDateOfYear = dateString.index(dateString.endIndex, offsetBy:-4)
        let dateOfYear = dateString[indexDateOfYear ..< endIndexDateOfYear]
        
        let day = String(dateOfDay)
        let month = String(dateOfMonth)
        let year = String(dateOfYear)
        
        return (year, month, day)
    }
    
    
    //show user appointment on Main Screen
    func showUserAppointment()  {
        let userID = user?.uid
        
        ref.child("AllUserID").child(userID!).observe(DataEventType.value, with: { snapshot in
            let valueString = snapshot.value as? String
            if var actualValue = valueString {
                let splitString = self.divideDate(dateString: actualValue)
                self.ref.child(splitString.y).child(splitString.m).child(splitString.d).child(userID!).observeSingleEvent(of: .value, with: { snapshot in
                    let enumerator = snapshot.children
               
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        
                        
                        if (rest.key == "Time") {
                          
                            self.appointmentTime.text = String(describing: rest.value!)
                            actualValue.insert("/", at: actualValue.index(actualValue.startIndex, offsetBy: 2))
                            actualValue.insert("/", at: actualValue.index(actualValue.startIndex, offsetBy: 6))
                            self.appointmentDate.text = actualValue
                        } else if (rest.key == "Name") {
                            self.name.text = String(describing: rest.value!)
                        }
                    }
                    //create notification
                    let year: Int = Int(splitString.y)!
                    let month: Int = Int(splitString.m)!
                    let day: Int = Int(splitString.d)!
                    
                    
                    if #available(iOS 10.0, *) {
                        let notification = UNMutableNotificationContent()
                        notification.title = "Natural Nails Too"
                        notification.subtitle = "Hi, " + self.name.text!
                        notification.body = "You have an appointment with us today, see you soon!"
                        notification.badge = 1
                        
                        // add notification for Mondays at 7:00 a.m.
                        var dateComponents = DateComponents()
                        dateComponents.year = year
                        dateComponents.month = month
                        dateComponents.day = day
                        dateComponents.hour = 7
                        

                        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        
                        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
         
                })
            } else {
                self.appointmentDate.text = " "
                self.appointmentTime.text = "No Appointment"
                self.name.text = " "
                
                //cancel notification
              
                if #available(iOS 10.0, *) {
                    UIApplication.shared.cancelAllLocalNotifications()
                    
                } else {
                    // Fallback on earlier versions
                }
            }
        })
       
    }
    //delete current shown appointment
    @IBAction func deleteApt(_ sender: UIButton) {
        let userID = user?.uid
        ref.child("AllUserID").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            let valueString = snapshot.value as? String
            if let actualValue = valueString {
                let splitString = self.divideDate(dateString: actualValue)
                self.ref.child(splitString.y).child(splitString.m).child(splitString.d).child(userID!).removeValue()
                self.ref.child("AllUserID").child(userID!).removeValue()
                self.showUserAppointment()
                print("your appointment has been deleted")
              
            } else {
                print("you dont have any appointment!")
            }
        })
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            // handle error here
            print("Error trying to sign out of Firebase: \(error.localizedDescription)")
        }
        
        Auth.auth().addStateDidChangeListener { Auth, user in
            if user != nil {
                // User is signed in. Show home screen
            } else {
            
                self.performSegue(withIdentifier: "BackToHome", sender: self)
                
            }
        }
    }
}
