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
    
    var order = Order()

    var orders: [Order] = []
    
    var selectedOrder : Order?
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    @IBOutlet weak var customerTableView: UITableView!
    
    func loadInRange(range: Range<Int>, completionBlock: ([Order ]?) -> Void) {
        // 1
        ParseHelper.timelineRequestforCurrentUser(range) {
            (result: [AnyObject]?, error: NSError?) -> Void in
            // 2
            let order = result as? [Order] ?? []
            // 3
            completionBlock(order)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 3
        let ordersFromThisUser = Order.query()
        //        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 4
        let query = PFQuery.orQueryWithSubqueries([ordersFromThisUser!])
        // 5
        query.includeKey("user")
        // 6
        query.orderByDescending("createdAt")
        
        // 7
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            // 8
            self.orders = result as? [Order] ?? []
            // 9
           self.customerTableView.reloadData()
        }
        
        let install = PFInstallation.currentInstallation()
        
        //        let currentInstallation = PFInstallation.currentInstallation()
        //        currentInstallation.addUniqueObject("Delivery", forKey: "channels")
        //        currentInstallation.saveInBackground()
        
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "customerView" {
            if let vc = segue.destinationViewController as? CurrentCustomerViewController, cell = sender as? CustomerTableViewCell {
//                vc.loadView()
                
                vc.order = cell.order
            }
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




extension DeliveryCreatedViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return orders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCellWithIdentifier("customerCell") as! CustomerTableViewCell
        
        cell.order = orders[indexPath.row]
        
        
        
        return cell
    }
    
}

extension DeliveryCreatedViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        selectedOrder = orders[indexPath.row]
        
        
        
    }
}



