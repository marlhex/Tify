//
//  ViewController.swift
//  Tify
//
//  Created by Ignacio Arias on 2020-07-20.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit
import UserNotifications

// a global constant
let burnFatSteps = ["No salt", "No sugar", "No saturated fat", "stick to water"]

class ViewController: UIViewController {

    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func schedulePlan(_ sender: Any) {
    
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            //First check the status, if the app is authorized to receive push notifications
            let status = settings.authorizationStatus
            if status == .denied || status == .notDetermined {
                DispatchQueue.main.async {
                    self.accessDeniedAlert()
                }
                return
            }
            self.introNotification()
        }
        
    }
    
    @IBAction func workingOut(_ sender: Any) {
        
        //Basic structure for permission checking
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                 
                 //First check the status, if the app is authorized to receive push notifications
                 let status = settings.authorizationStatus
                 if status == .denied || status == .notDetermined {
                     DispatchQueue.main.async {
                         self.accessDeniedAlert()
                     }
                     return
                 }
                 self.introNotification()
             }
          
    }
    
    //MARK: - Support Methods
     
     // A function to print errors to the console
     func printError(_ error:Error?,location:String){
         if let error = error{
             print("Error: \(error.localizedDescription) in \(location)")
         }
     }
    
    //A sample local notification for testing
    func introNotification(){
        // a Quick local notification.
        let time = 15.0
        counter += 1
        //Content
        let notifcationContent = UNMutableNotificationContent()
        notifcationContent.title = "Hello, Burner!!"
        notifcationContent.body = "Just a message to test permissions \(counter)"
        notifcationContent.badge = counter as NSNumber
        //Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        //Request
        let request = UNNotificationRequest(identifier: "intro", content: notifcationContent, trigger: trigger)
        //Schedule
        UNUserNotificationCenter.current().add(request) { (error) in
            self.printError(error, location: "Add introNotification")
        }
    }
    //An alert to indicate that the user has not granted permission for notification delivery.
    func accessDeniedAlert(){
        // presents an alert when access is denied for notifications on startup. give the user two choices to dismiss the alert and to go to settings to change thier permissions.
        let alert = UIAlertController(title: "Hello Burner", message: "Tify needs notifications to work properly, but they are currently turned off. Turn them on in settings.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(okayAction)
        alert.addAction(settingsAction)
        present(alert, animated: true) {
        }
    }


}

