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
let workoutSteps = ["Warmup", "stretch", "Legs", "core", "15 cardio"]

class ViewController: UIViewController {

    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func scheduleWorkout(_ sender: Any) {
    
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            //First check the status, if the app is authorized to receive push notifications
            let status = settings.authorizationStatus
            if status == .denied || status == .notDetermined {
                DispatchQueue.main.async {
                    self.accessDeniedAlert()
                }
                return
            }
//            self.introNotification()
            //Content
            let content = UNMutableNotificationContent()
            content.title = "An Scheduled workout"
            content.body = "Time to make a workout"
            content.threadIdentifier = "scheduled"
            content.categoryIdentifier = "snooze.category"
            
            
            //This is the attachment to fast read that resource .GIF
            let imageURL = URL(fileReferenceLiteralResourceName: "goku.gif")
            
            //Ctrl click on UNNotificationAttachment go to documentation to have a better reference on sizes & types
            let attachment = try! UNNotificationAttachment(identifier: "animation.goku.gif", url: imageURL, options: nil)
            
            content.attachments = [attachment]
            
            
            
            //This is the attachment to fast read that resource .WAV or properly MP3
//            let imageURL = URL(fileReferenceLiteralResourceName: "notification.wav")
//
//            let attachment = try! UNNotificationAttachment(identifier: "audio.Notification.wav", url: imageURL, options: nil)
//
//            content.attachments = [attachment]
            
            
            
            //This is the attachment to fast read that resource PNG
//            let imageURL = URL(fileReferenceLiteralResourceName: "CircleTafies.png")
//
//            let attachment = try! UNNotificationAttachment(identifier: "image.CircleTafies.png", url: imageURL, options: nil)
//
//            content.attachments = [attachment]
            
            //trigger
            var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
            dateComponents.second = dateComponents.second! + 15
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //Seconds = timeIntervalSinceReferenceDate
            let identifier = "message.scheduled.\(Date().timeIntervalSinceReferenceDate)"
            self.addNotification(trigger: trigger, content: content, identifier: identifier)
            
        }
        
    }
    
    
    var workoutNumber = 0
    
    @IBAction func makeWorkout(_ sender: Any) {
        
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
//                 self.introNotification()
            let content = self.notificationContent(title: "A timed plan step", body: "Making a plan!!")
            self.workoutNumber += 1
            content.subtitle = "Workout #\(self.workoutNumber)"
            content.categoryIdentifier = "workout.steps.category"
            content.threadIdentifier = "make.workout"
            
            
            //Lowest for true is 60 seconds. False can be 10.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            
            let identifier = "message.workout.\(self.workoutNumber)"
            self.addNotification(trigger: trigger, content: content, identifier: identifier)
             }
          
    }
    
    //MARK: - Example of custom methods
    
    //A mutable method to generate content
    func notificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = ["step" : 0]
        
        return content
    }
    
    
    
    //A pattern for trigger
    
    //identifier plays an important role on notification manager: What particular notification this is: So you can delete or modify as needed.
    func addNotification(trigger: UNNotificationTrigger, content: UNMutableNotificationContent, identifier: String) {
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            self.printError(error, location: "Add request for identifier:" + identifier)
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
        //Content: text & graphics within a notification
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

