//
//  MakeOrderViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/16/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse

class MakeOrderViewController: UIViewController, UITextViewDelegate {
    var order = Order()
    var delivery : Delivery?
    
    
    var selectedDelivery : Delivery?
    
    var deliveries: [Delivery] = []
    
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var enterOrder: UITextView!
    
    
    @IBAction func makeOrder(sender: AnyObject) {
        
        makeOrder()
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = delivery?.user?.username
        restaurant.text = delivery?.restaurant
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        deliveryFee.text = formatter.stringFromNumber(delivery!.deliveryFee)
        
        enterOrder.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter your order:"
        placeholderLabel.font = UIFont.italicSystemFontOfSize(enterOrder.font.pointSize)
        placeholderLabel.sizeToFit()
        enterOrder.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, enterOrder.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = count(enterOrder.text) != 0
    }
    
    func makeOrder () {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        order.user = .currentUser()
        order.deliveryInfo = delivery
        order.orderDetail = enterOrder.text
        
        
        // set up notifications
        if let orderer = order.user, deliverer = delivery?.user, pushQuery = PFInstallation.query(), username = orderer.username {
            pushQuery.whereKey("user", equalTo: deliverer)
            
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            push.setMessage("\(username) wants food!")
            push.sendPushInBackground()
        }
        //
        //        let me = PFUser.currentUser()
        //        let query = PFQuery(“delivery”)
        //
        //        //find the delivery
        //        query = PFQuery(“Order”)
        //        query.whereKey(“deliveryInfo”, delivery)
        //        query.whereKey(“completed”, false)
        
        
        
        // request geopoint
        //closures run at the same time so saveinBackground need to be inside the geolocation
        //        PFGeoPoint.geoPointForCurrentLocationInBackground {
        //            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
        //            deliver.location = geoPoint
        //        }
        order.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if (success) {
                //self.navigationController?.popViewControllerAnimated(true)
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        
    }
    
    var placeholderLabel : UILabel!
    
    
    func textViewDidChange(enterOrder: UITextView) {
        placeholderLabel.hidden = count(enterOrder.text) != 0
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            enterOrder.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        enterOrder.returnKeyType = UIReturnKeyType.Done
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "orderCreated" {
            if let vc = segue.destinationViewController as? WaitingViewController {
                vc.loadView() //if you get a nil value when unwrapping an optional
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

