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
        self.customerTableView.addSubview(self.refreshControl)
 
// disable back button and behavior
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setLeftBarButtonItem(nil, animated: false)
        
        if let delivery = delivery {
            username.text = delivery.user?.username
            restaurant.text = delivery.restaurant
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            timePicker.text = formatter.stringFromDate(delivery.deliveryStartTime)
            endTime.text = formatter.stringFromDate(delivery.endTime)

        }
    }
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var timePicker: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    var delivery : Delivery?
    
    // delete delivery
    @IBAction func deleteDelivery(sender: AnyObject) {
        
        
        delivery?.cancelled = true
        delivery?.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                // send notif to all 
                if let orderer = self.order.user, deliveryID = self.delivery?.objectId, pushQuery = PFInstallation.query(), username = self.order.deliveryInfo?.user?.username {
                    pushQuery.whereKey("user", equalTo: orderer)
                    
                    let data = [
                        "alert" : "\(username) has accepted your order!",
                        "deliveryID" : deliveryID,
                        "orderID" : self.order.objectId!,
                    ]
                    // Send push notification to query
                    let push = PFPush()
                    push.setQuery(pushQuery) // Set our Installation query
                    push.setData(data)
                    //                        push.setMessage("\(username) wants food!")
                    push.sendPushInBackground()
                }
                
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
            //        let alertController = UIAlertController(title: "Are you sure you want to cancel your delivery?", message: "You will lose all your customers", preferredStyle: .Alert)
            //
            //        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            //            println(action)
            //        }
            //        alertController.addAction(cancelAction)
            //
            //        let destroyAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
            //            delivery?.deleteInBackgroundWithBlock { (success, error) -> Void in
            //                if success {
            //                    self.navigationController?.popToRootViewControllerAnimated(true)
            //                }
            //            }
            //
            //        }
            //        alertController.addAction(destroyAction)
            //
            //        self.presentViewController(alertController, animated: true) {
            //            // ...
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
        refreshQuery()
        
        
        
    }
    func refreshQuery() {
        // 3
        let ordersFromThisUser = Order.query()
        
        //        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 4
        //        ordersFromThisUser?.whereKeyExists("accepted")
//        ordersFromThisUser?.whereKey("accepted", notEqualTo: false)
        ordersFromThisUser?.whereKey("deliveryInfo", equalTo: delivery!)
       ordersFromThisUser?.whereKey("completed", notEqualTo: true)
       ordersFromThisUser?.whereKey("cancelled", notEqualTo: true)
//        ordersFromThisUser?.whereKey("pending", equalTo: true)

        
        let query = PFQuery.orQueryWithSubqueries([ordersFromThisUser!])
        // 5
        query.includeKey("user")
        query.includeKey("deliveryInfo")
        query.includeKey("deliveryInfo.user")
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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? UITableViewCell {
            let indexPath = customerTableView.indexPathForCell(cell)!
            self.selectedOrder = orders[indexPath.row]
        }
        
        if segue.identifier == "pending" {
            if let vc = segue.destinationViewController as? OrderRequestViewController, cell = sender as? CustomerTableViewCell {
                vc.order = cell.order
            }
        }
        
        else if segue.identifier == "showCurrentCustomer" {
            if let vc = segue.destinationViewController as? CurrentCustomerViewController, cell = sender as? CustomerTableViewCell {
                
                vc.order = cell.order
            }
        }
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        
        refreshQuery()
        refreshControl.endRefreshing()
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
         let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if selectedOrder?.pending == true {
            
            performSegueWithIdentifier("pending", sender: cell)
        } else {
            performSegueWithIdentifier("showCurrentCustomer", sender: cell)
        }
        
        
    }
}



