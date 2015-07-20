//
//  DeliveryCreatedViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/16/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse

class DeliveryCreatedViewController: UIViewController {
    // self.dismiss viewController
    
    override func viewDidLoad() {

    }
    

    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var timePicker: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    var delivery : Delivery? {
        didSet{
            username.text = delivery?.user?.username
            restaurant.text = delivery?.restaurant
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            timePicker.text = formatter.stringFromDate(delivery!.deliveryStartTime)
            endTime.text = formatter.stringFromDate(delivery!.endTime)
            
        }
    }
    
    // delete delivery 
    @IBAction func deleteDelivery(sender: AnyObject) {
        
        delivery?.deleteInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("deleted the object")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    @IBOutlet weak var customerTableView: UITableView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/



