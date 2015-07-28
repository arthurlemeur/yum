//
//  AppDelegate.swift
//  yum
//
//  Created by Arthur Le Meur on 7/10/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var storyboard: UIStoryboard?
    var window: UIWindow?
    var homeVC : UINavigationController?
    var parseLoginHelper: ParseLoginHelper!
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                self.storyboard = UIStoryboard(name: "Main", bundle: nil)
                self.homeVC = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as? UINavigationController
                // 3
                self.window?.rootViewController!.presentViewController(self.homeVC!, animated:true, completion:nil)
                
                //set up notifications
                
                PFInstallation.currentInstallation()["user"] = user
                PFInstallation.currentInstallation().saveInBackground()
                
                //request facebook ID
                
                FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                    if let fbid = result["id"] as? String {
                        user.setObject(fbid, forKey: "fbid")
                        user["photoLarge"] = "https://graph.facebook.com/\(fbid)/picture?type=large"
                        user["photo"] = "https://graph.facebook.com/\(fbid)/picture?type=normal"
                        user.saveInBackground()
                    }
                })
            }
        }
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Order.registerSubclass()

        
        GMSServices.provideAPIKey("AIzaSyD86CI13CKtRWKbM3UcTQURoNiq91_Fxmc")
        
        
        Parse.setApplicationId("Eo8BrOyhWGnJVYKryzL2ur5gFjplCNRXEqe2Egyi", clientKey: "9cSbM877LoE2SR9L5NPajOciOEyuLkYnrkxKw0QI")
        
        // change write access to private
        let acl = PFACL()
        acl.setPublicReadAccess(true)
        PFACL.setDefaultACL(acl, withAccessForCurrentUser: true)
        
        
        //set up push notifications
        let userNotificationTypes = (UIUserNotificationType.Alert |  UIUserNotificationType.Badge |  UIUserNotificationType.Sound);
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        // Initialize Facebook
        // 1
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
        let startViewController: UIViewController;
        
        if (user != nil) {
            
            if PFInstallation.currentInstallation()["user"] == nil {
                PFInstallation.currentInstallation()["user"] = user
                PFInstallation.currentInstallation().saveInBackground()
            }
            
            //                completionHandler(UIBackgroundFetchResult.NoData)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            startViewController = storyboard.instantiateViewControllerWithIdentifier("NavigationController") as! UIViewController
        } else {
            // 4
            // Otherwise set the LoginViewController to be the first
            let loginViewController = PFLogInViewController()
            loginViewController.fields = .Facebook
            loginViewController.delegate = parseLoginHelper
            loginViewController.signUpController?.delegate = parseLoginHelper
            
            startViewController = loginViewController
        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
        
        //SEND NOTIF TO DELIVERER
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            
            if let orderID = userInfo["orderID"] as? String {
                //            println(order.objectId)
                let order = PFObject(withoutDataWithClassName: "Order", objectId: orderID)
                order.fetchIfNeededInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                    // Show photo view controller
                    if error != nil {
                        //                            completionHandler(UIBackgroundFetchResult.Failed)
                    } else if PFUser.currentUser() != nil {
                        //                    let orderVC = self.storyboard?.instantiateViewControllerWithIdentifier("OrderVC") as! UIViewController
                        //                    self.homeVC?.pushViewController(orderVC, animated: false)
                        //                    self.homeVC?.performSegueWithIdentifier("showOrderRequest", sender: self.homeVC)
                        //                    self.homeVC?.title = "WOW"
                        //                   self.homeVC?.navigationBar.hidden = true
                        let orderVC = self.storyboard!.instantiateViewControllerWithIdentifier("OrderVC") as! UIViewController
                        self.window?.rootViewController?.presentViewController(orderVC, animated: true, completion: nil)
                        
                        
                        
                        //                            completionHandler(UIBackgroundFetchResult.NewData)
                    } else {
                        //                            completionHandler(UIBackgroundFetchResult.NoData)
                    }
                }
            }
        }
       
//        //SEND NOTIF TO ORDERDER
//        if let userInfo = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
//            
//            if let deliveryID = userInfo["deliveryID"] as? String {
//                //            println(order.objectId)
//                let delivery = PFObject(withoutDataWithClassName: "Delivery", objectId: deliveryID)
//                delivery.fetchIfNeededInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
//                    // Show photo view controller
//                    if error != nil {
//                        //                            completionHandler(UIBackgroundFetchResult.Failed)
//                    } else if PFUser.currentUser() != nil {
//                        //                    let orderVC = self.storyboard?.instantiateViewControllerWithIdentifier("OrderVC") as! UIViewController
//                        //                    self.homeVC?.pushViewController(orderVC, animated: false)
//                        //                    self.homeVC?.performSegueWithIdentifier("showOrderRequest", sender: self.homeVC)
//                        //                    self.homeVC?.title = "WOW"
//                        //                   self.homeVC?.navigationBar.hidden = true
//                        let deliveryVC = self.storyboard!.instantiateViewControllerWithIdentifier("DeliveryVC") as! UIViewController
//                        self.window?.rootViewController?.presentViewController(deliveryVC, animated: true, completion: nil)
//                        
//                        
//                        
//                        //                            completionHandler(UIBackgroundFetchResult.NewData)
//                    } else {
//                        //                            completionHandler(UIBackgroundFetchResult.NoData)
//                    }
//                }
//            }
//        }
        
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            
            
            
        }
        
        // gets called before user is logged in
        
        func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
            //         Store the deviceToken in the current Installation and save it to Parse
            let installation = PFInstallation.currentInstallation()
            installation.setDeviceTokenFromData(deviceToken)
            if let user = PFUser.currentUser() {
                installation["user"] = PFUser.currentUser()
            }
            installation.saveInBackground()
        }
    
        func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
            println("Called")
            if let orderID = userInfo["orderID"] as? String {
                //            println(order.objectId)
                
                //QUERY for users
                let query = PFQuery(className: "Order")
                query.includeKey("user")
                query.includeKey("deliveryInfo")
                query.includeKey("deliveryInfo.user")
                
                query.getObjectInBackgroundWithId(orderID, block: { (object, error) -> Void in
                    // Show photo view controller
                    if error != nil {
                        completionHandler(UIBackgroundFetchResult.Failed)
                    } else if PFUser.currentUser() != nil {
                        //                    let orderVC = self.storyboard?.instantiateViewControllerWithIdentifier("OrderVC") as! UIViewController
                        //                    self.homeVC?.pushViewController(orderVC, animated: false)
                        //                    self.homeVC?.performSegueWithIdentifier("showOrderRequest", sender: self.homeVC)
                        //                    self.homeVC?.title = "WOW"
                        //                   self.homeVC?.navigationBar.hidden = true
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let orderVC = storyboard.instantiateViewControllerWithIdentifier("OrderVC") as! OrderRequestViewController
                        orderVC.order = object as? Order
                        if let vc = self.window?.rootViewController as? UINavigationController {
                            vc.pushViewController(orderVC, animated: true)
                        }
                        //                        self.window?.rootViewController?.presentViewController(, animated: true, completion: nil)
                        
                        
                        
                        completionHandler(UIBackgroundFetchResult.NewData)
                    } else {
                        completionHandler(UIBackgroundFetchResult.NoData)
                    }
                })
                
                
            }
            completionHandler(UIBackgroundFetchResult.NoData)
    }
    
    //SEND NOTIF TO ORDERER
    
//    func applicationForOrderer(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        println("Called")
//        if let deliveryID = userInfo["deliveryID"] as? String {
//            //            println(order.objectId)
//            let delivery = PFObject(withoutDataWithClassName: "Delivery", objectId: deliveryID)
//            
//            delivery.fetchIfNeededInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
//                // Show photo view controller
//                if error != nil {
//                    completionHandler(UIBackgroundFetchResult.Failed)
//                } else if PFUser.currentUser() != nil {
//                    //                    let orderVC = self.storyboard?.instantiateViewControllerWithIdentifier("OrderVC") as! UIViewController
//                    //                    self.homeVC?.pushViewController(orderVC, animated: false)
//                    //                    self.homeVC?.performSegueWithIdentifier("showOrderRequest", sender: self.homeVC)
//                    //                    self.homeVC?.title = "WOW"
//                    //                   self.homeVC?.navigationBar.hidden = true
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let deliveryVC = storyboard.instantiateViewControllerWithIdentifier("DeliveryVC") as! PickupViewController
//                    deliveryVC.delivery = object as? Delivery
//                    if let vc = self.window?.rootViewController as? UINavigationController {
//                        vc.pushViewController(deliveryVC, animated: true)
//                    }
//                    //                        self.window?.rootViewController?.presentViewController(, animated: true, completion: nil)
//                    
//                    
//                    
//                    completionHandler(UIBackgroundFetchResult.NewData)
//                } else {
//                    completionHandler(UIBackgroundFetchResult.NoData)
//                }
//            }
//        }
//        completionHandler(UIBackgroundFetchResult.NoData)
//    }
    
        func applicationWillResignActive(application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        }
        
        func applicationDidEnterBackground(application: UIApplication) {
            // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
            // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        }
        
        func applicationWillEnterForeground(application: UIApplication) {
            // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        }
        
        func applicationDidBecomeActive(application: UIApplication) {
            FBSDKAppEvents.activateApp()
        }
        
        func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
            
        }
        
        func applicationWillTerminate(application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
}

