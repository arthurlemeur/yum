//
//  MakeOrderViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/16/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit

class MakeOrderViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var enterOrder: UITextView!
    

    
    var delivery : Delivery?
    
    

    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

