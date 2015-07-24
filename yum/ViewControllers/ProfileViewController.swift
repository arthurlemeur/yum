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
        self.parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let user = user {
                // if login was successful, display the TabBarController
                // 2
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
        let loginViewController = PFLogInViewController()
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        loginViewController.delegate = self.parseLoginHelper
        loginViewController.signUpController?.delegate = self.parseLoginHelper
        self.presentViewController(loginViewController, animated: true, completion: nil)
        
        
    }
    
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
