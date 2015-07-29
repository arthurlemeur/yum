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
//        if enterOrder.text.isEmpty{
//                    var alert = UIAlertController(title: "Hey", message: "This is  one Alert", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }
//                else {
        makeOrder()
//                }
    }
    
    

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = delivery?.user?.username
        restaurant.text = delivery?.restaurant
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        deliveryFee.text = "charges \(formatter.stringFromNumber(delivery!.deliveryFee)) for delivery"
        
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
        
        //changing read access
        let acl = PFACL()
        acl.setWriteAccess(true, forUser: PFUser.currentUser()!)
        acl.setWriteAccess(true, forUser: delivery!.user!)
//        acl.setReadAccess(true, forUser: PFUser.currentUser())
        acl.setPublicReadAccess(true)
        order.ACL = acl

        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            self.order.location = geoPoint
            self.order.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if (success) {
                    //self.navigationController?.popViewControllerAnimated(true)
                    // set up notifications
                    if let orderer = self.order.user, let orderID = self.order.objectId, let deliverer = self.delivery?.user, pushQuery = PFInstallation.query(), username = orderer.username {
                        pushQuery.whereKey("user", equalTo: deliverer)
                        
                        let data = [
                            "alert" : "\(username) wants food!",
                            "orderID" : orderID
                        ]
                        // Send push notification to query
                        let push = PFPush()
                        push.setQuery(pushQuery) // Set our Installation query
                        push.setData(data)
//                        push.setMessage("\(username) wants food!")
                        push.sendPushInBackground()
                    }
                    
                    self.performSegueWithIdentifier("orderCreated", sender: nil)
                    
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            
        }
        

        
    }
    
    var placeholderLabel : UILabel!
    
    
    func textViewDidChange(enterOrder: UITextView) {
        placeholderLabel.hidden = count(enterOrder.text) != 0
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Set character limits on each of the fields.
        if text == "\n"
        {
            enterOrder.resignFirstResponder()
            return false
        }
        let descriptionCharLimit = 200
        return (count(textView.text) + count(text) - range.length) <= descriptionCharLimit
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

