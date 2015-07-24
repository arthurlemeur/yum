//
//  ProfileViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/20/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4

class ProfileViewController: UIViewController {
    
    var parseLoginHelper: ParseLoginHelper!


    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var signOut: UIButton!
    
    @IBAction func signOut(sender: AnyObject) {
        PFUser.logOut()
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
                //set up notifications
                
                PFInstallation.currentInstallation()["user"] = user
                PFInstallation.currentInstallation().saveInBackground()
                
                //request facebook ID
                
                FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                    if let fbid = result["id"] as? String {
                        user.setObject(fbid, forKey: "fbid")
                        user.saveInBackground()
                    }
                    if let picture = result["picture"] as? PFFile {
                        user.setObject(picture, forKey: "picture")
                        user.saveInBackground()
                    }
                })
            }
        }

        let loginViewController = PFLogInViewController()
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        loginViewController.delegate = parseLoginHelper
        loginViewController.signUpController?.delegate = parseLoginHelper
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }//This is a comment
    
    var delivery : Delivery?

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = PFUser.currentUser()?.username


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
