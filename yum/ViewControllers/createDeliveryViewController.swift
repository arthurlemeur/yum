//
//  createDeliveryViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/13/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse

class createDeliveryViewController: UIViewController, UITextFieldDelegate {
    
    var delivery = Delivery()
    
    //go to home screen
    @IBAction func createDelivery(sender: AnyObject) {
        
//        if textField.text.isEmpty{
//            var alert = UIAlertController(title: "Hey", message: "This is  one Alert", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "Working!!", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
//        else {
            createDelivery()
//        }
    }
    
    
    @IBOutlet weak var textField: UITextField! = nil
    @IBOutlet weak var deliveryFee: UISegmentedControl!
    var deliveryFeeInDollars = 0
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // sets delivery fee
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch deliveryFee.selectedSegmentIndex
        {
        case 0:
            deliveryFeeInDollars = 0
        case 1:
            deliveryFeeInDollars = 1
        case 2:
            deliveryFeeInDollars = 2
        case 3:
            deliveryFeeInDollars = 3
        default:
            break;
        }
    }
    
    // loading in background
    
    func createDelivery () {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        delivery.deliveryFee = deliveryFeeInDollars
        delivery.deliveryStartTime = datePicker.date
        delivery.restaurant = textField.text
        delivery.user = .currentUser()

        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            self.delivery.location = geoPoint
            self.delivery.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if (success) {
                    //self.navigationController?.popViewControllerAnimated(true)
                    self.performSegueWithIdentifier("deliveryCreated", sender: nil)
                    
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            
        }
    }

    
    // hides keyboard after pressing return
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //set return button to done on keyboard
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.returnKeyType = UIReturnKeyType.Done
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        datePickerChanged(datePicker)
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")

        
        
        // Do any additional setup after loading the view.
    }
    
    // display end time (date picker + 1)
    
    func datePickerChanged(datePicker:UIDatePicker) {
        delivery.deliveryStartTime = datePicker.date
        var dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(delivery.endTime)
        dateLabel.text =  "finish delivery at \(strDate)"
        
        
    }
    
    //restrict textfield characters
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = count(textField.text.utf16) + count(string.utf16) - range.length
        
        return length <= 15
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //go to back to home view controller
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "deliveryCreated" {
            if let vc = segue.destinationViewController as? DeliveryCreatedViewController {
                vc.delivery = delivery
            }
        }
    }
    
    
}
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass th selected object to the new view controller.
}
*/

