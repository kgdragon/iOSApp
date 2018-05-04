//
//  ViewController.swift
//  BLinApp
//
//  Created by kito on 10/19/17.
//  Copyright © 2017 kito. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import UserNotifications
class ViewController: UIViewController {

    var ref: DatabaseReference!
   
    
    var listArray = [String]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
                didAllow, error in
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "loggedInScreen", sender: self)
        }
    }

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    //create account function
    @IBAction func signUp(_ sender: UIButton) {
    
        if let email = userName.text, let password = passWord.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, Error in
                if let firebaseError = Error {
                    
                    let alert = UIAlertController(title: firebaseError.localizedDescription, message: "Click forgot password if you are the account owner", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak alert] (_) in
                    }))
                    self.present(alert, animated:  true, completion:  nil)
                    print(firebaseError.localizedDescription)
                    return
                }
                let alert = UIAlertController(title: "Account created", message: "Done", preferredStyle: .alert)
 
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak alert] (_) in
                }))
                self.present(alert, animated:  true, completion:  nil)
                print("success!")
 
            })
        }
    }
    
    //forgot password function
    @IBAction func forgotPassword(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Reset Password", message: "Enter an email reset", preferredStyle: .alert)
        let alertSent = UIAlertController(title: "Reset Password", message: "Message sent!", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            alertSent.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak alert] (_) in
                
            }))
           self.present(alertSent, animated:  true, completion:  nil)
            Auth.auth().sendPasswordReset(withEmail: textField?.text ?? "") { Error in
                if let firebaseError = Error {
                    print(firebaseError.localizedDescription)
                    return
                }
            }
            print(textField?.text ?? "")
        }))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    //singIn function
    @IBAction func signIn(_ sender: UIButton) {
        if let email = userName.text, let password = passWord.text {
            
            //non Admin login
           Auth.auth().signIn(withEmail: email, password: password, completion: { user, Error in
            if let firebaseError = Error {
                let warningAlert = UIAlertController(title: "Error Login!", message: "Make sure your email and password are correct!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.default)
                {
                    (UIAlertAction) -> Void in
                }
                warningAlert.addAction(alertAction)
                self.present(warningAlert, animated: true)
                {
                    () -> Void in
                }
                
                print(firebaseError.localizedDescription)
                return
            }
            
            //fixed admin email for now, will store in firebase later
            if (email == "kitomam@yahoo.com") {
                
                print("success!")
                self.performSegue(withIdentifier: "goToAdmin", sender: self)
            } else {
                print("success!")
                self.performSegue(withIdentifier: "loggedInScreen", sender: self)
            }
           })
        }
  }
   
}
