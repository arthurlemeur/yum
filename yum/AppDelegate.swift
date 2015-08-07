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
import LayerKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var storyboard: UIStoryboard?
    var window: UIWindow?
    var homeVC : UINavigationController?
    var parseLoginHelper: ParseLoginHelper!
    var layerClient: LYRClient!

    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {
            [unowned self] (user, error) in
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
                    println(result)
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
            loginViewController.fields = (.Facebook)
            // change this to your own logo later
            loginViewController.logInView!.logo = UIImageView(image: UIImage(named:"yum"))
            //         loginViewController.logInView?.backgroundColor = UIImage(named:"BGPic"))
            loginViewController.logInView?.backgroundColor = UIColor(red: 78/256, green: 100/256, blue: 127/256, alpha: 1)
            
            //    loginViewController.logInView?.
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
            
            println("Called")
            if let orderID = userInfo["orderID"] as? String {
                //            println(order.objectId)
                
                //QUERY for users
                let query = PFQuery(className: "Order")
                query.includeKey("user")
                query.includeKey("deliveryInfo")
                query.includeKey("deliveryInfo.user")
                
                query.getObjectInBackgroundWithId(orderID, block: { (object, error) -> Void in
                    let order = object as! Order
                    println(order.user?.objectId)
                    println(order.deliveryInfo?.user?.objectId)
                    println(PFUser.currentUser()?.objectId)
                    if error != nil {
               //         completionHandler(UIBackgroundFetchResult.Failed)
                    }
                    else if PFUser.currentUser()?.objectId == order.deliveryInfo?.user?.objectId && order.deliveryInfo?.cancelled != true {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let orderVC = storyboard.instantiateViewControllerWithIdentifier("OrderVC") as! OrderRequestViewController
                        orderVC.order = object as? Order
                        if let vc = self.window?.rootViewController as? UINavigationController {
                            vc.pushViewController(orderVC, animated: true)
                        }
                 //       completionHandler(UIBackgroundFetchResult.NewData)
                        
                    }
                    else if PFUser.currentUser()?.objectId == order.user?.objectId {
                        if order.accepted == true && order.deliveryInfo?.cancelled != true  {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let deliveryVC = storyboard.instantiateViewControllerWithIdentifier("DeliveryVC") as! PickupViewController
                            deliveryVC.delivery = order.deliveryInfo!
                            deliveryVC.order = order
                            
                            if let vc = self.window?.rootViewController as? UINavigationController {
                                vc.pushViewController(deliveryVC, animated: true)
                            }
                     //       completionHandler(UIBackgroundFetchResult.NoData)
                        } else if order.accepted == false && order.deliveryInfo?.cancelled != true {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let HomeController = storyboard.instantiateViewControllerWithIdentifier("HomeController") as! HomeViewController
                            HomeController.delivery = order.deliveryInfo!
                            if let vc = self.window?.rootViewController as? UINavigationController {
                                vc.pushViewController(HomeController, animated: true)
                                let alertController = UIAlertController(title: "Order Rejected, Sorry", message:
                                    "please choose a different order", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                
                                self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                            }
                            
               //             completionHandler(UIBackgroundFetchResult.NoData)
                        } else if order.deliveryInfo?.cancelled == true {
                            if let vc = self.window?.rootViewController as? UINavigationController {
                                let alertController = UIAlertController(title: "Delivery Cancelled, Sorry", message:
                                    "please choose a different order", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                
                                vc.presentViewController(alertController, animated: true, completion: nil)
                            }
                            
             //               completionHandler(UIBackgroundFetchResult.NoData)
                        }
                    }
                    else {
 //                       completionHandler(UIBackgroundFetchResult.NoData)
                    }
                    
                })
                
                
            } else if let deliveryID = userInfo["deliveryID"] as? String, isOrder = userInfo["isOrder"] as? Bool where isOrder == true {
                
                let deliveryQuery = Delivery.query()!
                
                deliveryQuery.getObjectInBackgroundWithId(deliveryID, block: { (delivery, error) -> Void in
                    if let delivery = delivery as? Delivery {
                        let query = Order.query()!
                        
                        
                        query.whereKey("deliveryInfo", equalTo: delivery)
                        query.whereKey("user", equalTo: PFUser.currentUser()!)
                        
                        query.includeKey("user")
                        query.includeKey("deliveryInfo")
                        query.includeKey("deliveryInfo.user")
                        
                        query.getFirstObjectInBackgroundWithBlock({ (order, error) -> Void in
                            if let vc = self.window?.rootViewController as? UINavigationController {
                                let alertController = UIAlertController(title: "Delivery Cancelled, Sorry", message:
                                    "please choose a different order", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                
                                
                                vc.presentViewController(alertController, animated: true, completion: { () -> Void in
                                    vc.popToRootViewControllerAnimated(true)
                                })
                            }
                            
                   //         completionHandler(UIBackgroundFetchResult.NoData)
                        })
                    }
                })
                
            }
            
   //         completionHandler(UIBackgroundFetchResult.NewData)
            
        }
        
        
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
                let order = object as! Order
                println(order.user?.objectId)
                println(order.deliveryInfo?.user?.objectId)
                println(PFUser.currentUser()?.objectId)
                if error != nil {
                    completionHandler(UIBackgroundFetchResult.Failed)
                }
                else if PFUser.currentUser()?.objectId == order.deliveryInfo?.user?.objectId && order.deliveryInfo?.cancelled != true {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let orderVC = storyboard.instantiateViewControllerWithIdentifier("OrderVC") as! OrderRequestViewController
                    orderVC.order = object as? Order
                    if let vc = self.window?.rootViewController as? UINavigationController {
                        vc.pushViewController(orderVC, animated: true)
                    }
                    completionHandler(UIBackgroundFetchResult.NewData)
                    
                }
                else if PFUser.currentUser()?.objectId == order.user?.objectId {
                    if order.accepted == true && order.deliveryInfo?.cancelled != true  {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let deliveryVC = storyboard.instantiateViewControllerWithIdentifier("DeliveryVC") as! PickupViewController
                        deliveryVC.delivery = order.deliveryInfo!
                        deliveryVC.order = order
                        
                        if let vc = self.window?.rootViewController as? UINavigationController {
                            vc.pushViewController(deliveryVC, animated: true)
                        }
                        completionHandler(UIBackgroundFetchResult.NoData)
                    } else if order.accepted == false && order.deliveryInfo?.cancelled != true {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let HomeController = storyboard.instantiateViewControllerWithIdentifier("HomeController") as! HomeViewController
                        HomeController.delivery = order.deliveryInfo!
                        if let vc = self.window?.rootViewController as? UINavigationController {
                            vc.pushViewController(HomeController, animated: true)
                            let alertController = UIAlertController(title: "Order Rejected, Sorry", message:
                                "please choose a different order", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            
                            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                        completionHandler(UIBackgroundFetchResult.NoData)
                    } else if order.deliveryInfo?.cancelled == true {
                        if let vc = self.window?.rootViewController as? UINavigationController {
                            let alertController = UIAlertController(title: "Delivery Cancelled, Sorry", message:
                                "please choose a different order", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            
                            vc.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                        completionHandler(UIBackgroundFetchResult.NoData)
                    }
                }
                else {
                    completionHandler(UIBackgroundFetchResult.NoData)
                }
                
            })
            
            
        } else if let deliveryID = userInfo["deliveryID"] as? String, isOrder = userInfo["isOrder"] as? Bool where isOrder == true  {
            
            let deliveryQuery = Delivery.query()!
            
            deliveryQuery.getObjectInBackgroundWithId(deliveryID, block: { (delivery, error) -> Void in
                if let delivery = delivery as? Delivery {
                    let query = Order.query()!
                    
                    
                    query.whereKey("deliveryInfo", equalTo: delivery)
                    query.whereKey("user", equalTo: PFUser.currentUser()!)
                    query.whereKey("accepted", notEqualTo: false)
                    
                    query.includeKey("user")
                    query.includeKey("deliveryInfo")
                    query.includeKey("deliveryInfo.user")
                    query.includeKey("accepted")
                    
                    query.getFirstObjectInBackgroundWithBlock({ (order, error) -> Void in
                        if let vc = self.window?.rootViewController as? UINavigationController {
                            let alertController = UIAlertController(title: "Delivery Cancelled, Sorry", message:
                                "please choose a different order", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                            
                            
                            vc.presentViewController(alertController, animated: true, completion: { () -> Void in
                                vc.popToRootViewControllerAnimated(true)
                            })
                        }
                        
                        completionHandler(UIBackgroundFetchResult.NoData)
                    })
                }
            })
            
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    
    
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