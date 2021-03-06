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
    
    @IBOutlet weak var picture: UIImageView!
    @IBAction func signOut(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Sign out of your account?", message: "You will have to login again", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            println(action)
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
            delivery?.deleteInBackgroundWithBlock { (success, error) -> Void in
                if success {
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
                    loginViewController.fields = .Facebook
                    loginViewController.delegate = self.parseLoginHelper
                    loginViewController.signUpController?.delegate = self.parseLoginHelper
                    self.presentViewController(loginViewController, animated: true, completion: nil)
                }
            }
            
        }
        alertController.addAction(destroyAction)
        self.presentViewController(alertController, animated: true) {
        }
        
    }
    
    var delivery : Delivery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = PFUser.currentUser()?.username
        picture.layer.masksToBounds = false
        picture.layer.cornerRadius = picture.frame.height/2
        picture.clipsToBounds = true
        if let urlString = PFUser.currentUser()?.valueForKey("photoLarge") as? String, url = NSURL(string: urlString) {
            // Add placeholder later
            picture.sd_setImageWithURL(url, placeholderImage: nil)
        }

        
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
