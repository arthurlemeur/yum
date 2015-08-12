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
        self.yourLabel.hidden = true;
        self.customerTableView.tableFooterView = UIView()
        self.customerTableView.addSubview(self.refreshControl)

// disable back button and behavior
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: false)
        //self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setLeftBarButtonItem(nil, animated: false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        if let delivery = delivery {
            restaurant.text = delivery.restaurant
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            timePicker.text = formatter.stringFromDate(delivery.deliveryStartTime)
            println(count(timePicker.text!))
            endTime.text = formatter.stringFromDate(delivery.endTime)

        }
    }
    
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var timePicker: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var yourLabel: UILabel!
    
    var delivery : Delivery?
    
    // delete delivery
    @IBAction func deleteDelivery(sender: AnyObject) {
        var alert=UIAlertController(title: "Are you sure you want to cancel your delivery?", message: "You will lose all your customers", preferredStyle: UIAlertControllerStyle.Alert);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            self.delivery?.cancelled = true
            self.delivery?.saveInBackgroundWithBlock { (success, error) -> Void in
                if success {
                    if let delivery = self.delivery, query = Order.query(), pushQuery = PFInstallation.query(), deliveryID = self.delivery?.objectId {
                        
                        query.whereKey("deliveryInfo", equalTo: delivery)
                        query.whereKey("cancelled", notEqualTo: true)
                        query.whereKey("accepted", notEqualTo: false)
                        pushQuery.whereKey("user", matchesKey: "user", inQuery: query)
                        
                        let data : [NSObject : AnyObject] = [
                            "alert" : "Your order has been cancelled, sorry",
                            "deliveryID" : deliveryID,
                            "isOrder" : true,
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
                
                
            }
            
        }));
        presentViewController(alert, animated: true, completion: nil);
        
        
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
       ordersFromThisUser?.whereKey("accepted", notEqualTo: false)
        ordersFromThisUser?.whereKey("deliveryInfo", equalTo: delivery!)
       ordersFromThisUser?.whereKey("completed", notEqualTo: true)
       ordersFromThisUser?.whereKey("cancelled", notEqualTo: true)
//        ordersFromThisUser?.whereKey("pending", notEqualTo: false)

        
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
        // If the number of tasks are 0
        if (orders.count == 0) {
            // Set the background hidden view to show up
            yourLabel.hidden = false
            
            // Disable the edit button
            self.navigationItem.rightBarButtonItem?.enabled = false
            
        } else {
            // Set the background hidden view to dissapear
            yourLabel.hidden = true
            
            // Enbales the edit button
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        
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
        self.selectedOrder = orders[indexPath.row]
        
        if selectedOrder?.pending == true {
            
            performSegueWithIdentifier("pending", sender: cell)
        } else {
            performSegueWithIdentifier("showCurrentCustomer", sender: cell)
        }
        
        
    }
}



