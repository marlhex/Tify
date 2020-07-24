//
//  SceneDelegate.swift
//  Tify
//
//  Created by Ignacio Arias on 2020-07-20.
//  Copyright © 2020 Ignacio Arias. All rights reserved.
//

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let ncDelegate = NotificationCenterDelegate()
    
    func setCategories() {
        
        //Actions
        let nextStepAction = UNNotificationAction(identifier: "next.step", title: "Next", options: [])
        let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Title", options: [])
        
        //Red label .destructive (makes the user think twice before clicked
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancel Workout", options: [.destructive])
        
        
        //Categories
        
        //"actual actions array that will show up (in that order)"
        let workoutStepsCategory = UNNotificationCategory(identifier: "workout.steps.category", actions: [nextStepAction, snoozeAction, cancelAction], intentIdentifiers: [], options: [])
        
        let snoozeStepsCategory = UNNotificationCategory(identifier: "snooze.steps.category", actions: [snoozeAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([workoutStepsCategory, snoozeStepsCategory])
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        
        //Keep in mind the .provisional to ask the user if he wants to keep reciving or not. pros good ux, cons: not dd
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            self.printError(error, location: "Request Authorization")
        }
        
        //With this notifications can appear in other or same view (all view controllers)
        UNUserNotificationCenter.current().delegate = ncDelegate
        
        setCategories()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    //MARK: - Support Methods
         
         // A function to print errors to the console
         func printError(_ error:Error?,location:String){
             if let error = error{
                 print("Error: \(error.localizedDescription) in \(location)")
             }
         }


}

