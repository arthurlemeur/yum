//
//  ProfileViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/20/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var signOut: UIButton!
    
    
    var delivery : Delivery?

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = delivery?.user?.username


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
