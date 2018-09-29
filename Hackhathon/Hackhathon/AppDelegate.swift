//
//  AppDelegate.swift
//  Hackhathon
//
//  Created by Nehal on 28/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        self.deleteTheUser()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
              self.makeTheUserOffline()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.makeUserOnline()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.deleteTheUser()
        self.saveContext()
    }
    // MARK: - Make the user offline
    func makeUserOnline() {
        if let autoIDKey = UserDefaults.standard.value(forKey: "AutoID") as? String {
            if let email = UserDefaults.standard.value(forKey: "email") as? String {
                let userData = ["id":autoIDKey,
                                "Email": email,
                                "isOnline": true,
                                "isPlaying": false
                    ] as [String : Any]
                _ = Database.database().reference().child("Users").child(autoIDKey).updateChildValues(userData)
            }
        }
    }
    func makeTheUserOffline() {
        if let autoIDKey = UserDefaults.standard.value(forKey: "AutoID") as? String {
            if let email = UserDefaults.standard.value(forKey: "email") as? String {
                let userData = ["id":autoIDKey,
                                "Email": email,
                                "isOnline": false,
                                "isPlaying": false
                    ] as [String : Any]
                 _ = Database.database().reference().child("Users").child(autoIDKey).updateChildValues(userData)
            }
        }
    }
    func deleteTheUser() {
        if let autoIDKey = UserDefaults.standard.value(forKey: "AutoID") as? String {
        _ = Database.database().reference().child("Users").child(autoIDKey).setValue(nil)
        }
        if let autoIDKey = UserDefaults.standard.value(forKey: "WantToPlayKey") as? String {
            _ = Database.database().reference().child("WantToPlay").child(autoIDKey).setValue(nil)
        }
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Hackhathon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

