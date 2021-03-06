//
//  AppDelegate.swift
//  Mesa
//
//  Created by Vibes on 4/25/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import FacebookCore
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard : UIStoryboard?
    var myVC : UIViewController?
    
    class func isIPhone5 () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        
//        if UserDefaults.standard.bool(forKey: "onboardingHasAppeared") {
//            
//            self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
//
//            
//        }
        
//        Branch.getInstance().initSession(launchOptions: launchOptions) { params, error in
//            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
//            // params will be empty if no data found
//            // ... insert custom logic here ...
//            print(params as? [String: AnyObject] ?? {})
//        }
        
        let branch: Branch = Branch.getInstance()
        branch.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: {params, error in
            // If the key 'pictureId' is present in the deep link dictionary
            if error == nil && params!["+clicked_branch_link"] != nil && params!["pictureId"] != nil {
//                guard let data = params as? [String: AnyObject] else { return }
//                self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "")
//                data["itemID"]
                print("Hello")
                print(params as? [String: AnyObject] ?? {})
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                myVC.currentItemCount = (params!["itemID"] as? Int)!
                // load the view to show the picture
            } else {
                // load your normal view
            }
        })
        
        return true

        
    }
    
    // Respond to URI scheme links
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().application(app,
                                         open: url,
                                         options:options
        )
        
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
        return true
    }
    
    // 
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if LISDKCallbackHandler.shouldHandle(url) {
            return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return true
    }
    
    // Respond to Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().continue(userActivity)
        
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
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting. Facebook.
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: - Core Data stack
    
  

    // MARK: - Core Data Saving support



}

