//
//  AppDelegate.swift
//  OddJobs
//
//  Created by Nicolas Rodriguez on 7/10/17.
//  Copyright © 2017 Nicolas Rodriguez. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces
import GooglePlacePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) in
            configuration.applicationId = "oddJobs"
            configuration.clientKey = "oddJobsMasterKey12345"
            configuration.server = "https://calm-shore-72958.herokuapp.com/parse"
        }))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("logoutNotification"), object: nil, queue: OperationQueue.main) { (Notification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginViewController")
            self.window?.rootViewController = vc
        }
        
        if let currentUser = PFUser.current() {
//            print("Welcome back \(currentUser.name!)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "tabBarController")
            window?.rootViewController = homeViewController
        }

        GMSPlacesClient.provideAPIKey("AIzaSyBIWErF-n_u-qq0SpN9R0qr2DPhdF--Pzg")
        GMSServices.provideAPIKey("AIzaSyBIWErF-n_u-qq0SpN9R0qr2DPhdF--Pzg")
        
        let navigationBarAppearance = UINavigationBar.appearance()
        let tabBarAppearance = UITabBar.appearance()
        let color = ColorObject()
        navigationBarAppearance.barTintColor = color.myLightColor
        navigationBarAppearance.tintColor = color.myRedColor
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : color.myRedColor, NSFontAttributeName : UIFont(name: "Helvetica", size: 20)!]
        tabBarAppearance.barTintColor = color.myLightColor
        tabBarAppearance.tintColor = color.myRedColor
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSForegroundColorAttributeName: color.myRedColor, NSFontAttributeName: UIFont(name:"Helvetica", size: 15)!], for: .normal)
        
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

extension AppDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is UINavigationController {
            let vc = viewController as! UINavigationController
            if vc.topViewController is PostViewController {
                if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "PostNavController") {
                    tabBarController.present(newVC, animated: true)
                    return false
                }
            }
        }   
    return true
    }
}
