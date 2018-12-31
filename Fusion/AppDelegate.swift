//
//  AppDelegate.swift
//  Fusion
//
//  Created by Charles Imperato on 12/18/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import UserNotifications
import wvslib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // - Set the base service path
        CommonProperties.servicesBasePath.setValue("https://www.fusionatx.com/")

        // - Create the main window
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        // - Configure the navigation controller
        let nav = SharedNavigationController.init(rootViewController: HomeViewController.init(withPresenter: HomePresenter()))

        // - Set the root to be the events view
        window?.rootViewController = nav

        // - Present the main window
        window?.makeKeyAndVisible()
        
        // - Allow for notifications to be handled
        UNUserNotificationCenter.current().delegate = self
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// - Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let nav = self.window?.rootViewController as? UINavigationController, let topView = nav.topViewController else {
            return
        }
        
        let body = notification.request.content.body
        (topView as? Notifiable & UIViewController)?.notify(message: body, 5, UIColor.red)

        completionHandler(.sound)
    }
}
