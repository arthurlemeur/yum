//
//  WaitingViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/17/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse

class WaitingViewController: UIViewController {
    var order = Order()
    
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var cancelOrder: UIButton!
    @IBAction func cancelOrder(sender: AnyObject) {
        var alert=UIAlertController(title: "Are you sure you want to cancel your order?", message: "", preferredStyle: UIAlertControllerStyle.Alert);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            //                    self.order = order
            self.order.cancelled = true
            self.order.pending = false
            self.order.saveInBackgroundWithBlock({ (success, error) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            })
//            self.order.saveInBackground()
            
            
        }));
        presentViewController(alert, animated: true, completion: nil);
    }
    
    
    var delivery = Delivery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setLeftBarButtonItem(nil, animated: false)
        picture.layer.masksToBounds = false
        picture.layer.cornerRadius = picture.frame.height/2
        picture.clipsToBounds = true
        if let urlString = delivery.user?["photoLarge"] as? String, url = NSURL(string: urlString) {
            // Add placeholder later
            picture.sd_setImageWithURL(url, placeholderImage: nil)
        }
        username.text = delivery.user?.username
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        deliveryFee.text = "charges \(formatter.stringFromNumber(delivery.deliveryFee)!) for delivery"
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "orderAccepted" {
            if let vc = segue.destinationViewController as? WaitingViewController {
//                vc.loadView() //if you get a nil value when unwrapping an optional
                vc.delivery = delivery
            }
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
    
}
