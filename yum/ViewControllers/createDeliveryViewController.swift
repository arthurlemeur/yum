//
//  createDeliveryViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/13/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit

class createDeliveryViewController: UIViewController, UITextFieldDelegate {
    @IBAction func goHome(sender: AnyObject) {
        createDelivery()
    }
    
    
    @IBOutlet weak var textField: UITextField! = nil
    @IBOutlet weak var deliveryFee: UISegmentedControl!
    var deliveryFeeInDollars = 0
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    // sets delivery fee
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch deliveryFee.selectedSegmentIndex
        {
        case 0:
            deliveryFeeLabel.text = "Adam delivers for free!";
            deliveryFeeInDollars = 0
        case 1:
            deliveryFeeLabel.text = "Adam delivers for $1";
            deliveryFeeInDollars = 1
        case 2:
            deliveryFeeLabel.text = "Adam delivers for $2"
            deliveryFeeInDollars = 2
        case 3:
            deliveryFeeLabel.text = "Adam delivers for $3"
            deliveryFeeInDollars = 3
        default:
            break;
        }
    }
    
    func createDelivery () {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var deliver = Delivery()
        deliver.deliveryFee = deliveryFeeInDollars
        deliver.deliveryStartTime = datePicker.date
        deliver.restaurant = textField.text
        
        
        deliver.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            if (success) {
                self.navigationController?.popViewControllerAnimated(true)
                // The object has been saved.
            } else {
                // There was a problem, check error.description
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
        
        
        // Do any additional setup after loading the view.
    }
    
    // display end time
    
    func datePickerChanged(datePicker:UIDatePicker) {
        let laterDate = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.CalendarUnitHour,
            value: 1,
            toDate: datePicker.date,
            options: NSCalendarOptions.WrapComponents)
        
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(laterDate!)
        dateLabel.text = strDate
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
// Pass th selected object to the new view controller.
}
*/

