//
//  MakeOrderViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/16/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit

class MakeOrderViewController: UIViewController {

    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    
    var delivery : Delivery? {
        didSet{
            username.text = delivery?.user?.username
            restaurant.text = delivery?.restaurant
            let formatter = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            deliveryFee.text = formatter.stringFromNumber(delivery!.deliveryFee)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
