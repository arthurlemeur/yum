//
//  HomeViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/10/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var current: UILabel!
    
    var delivery = Delivery()
    
    var selectedDelivery : Delivery?
    
    var deliveries: [Delivery] = []
    var order = Order()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl)
        current.text = "Current Deliveries"
        
    }
    
    func checkForCurrentDelivery() {
        let query = Delivery.query()!
        
        query.whereKey("expiration", greaterThanOrEqualTo: NSDate())
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("cancelled", notEqualTo: true)
        
        // 5
        query.includeKey("user")
        // 6
        query.orderByDescending("createdAt")
        
        // 7
        
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if let delivery = object as? Delivery {
                self.performSegueWithIdentifier("showCurrentDelivery", sender: delivery)
            }
        }
        
    }
    
    func checkForOrderRequest() {
        let query = Order.query()!
        
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("deliveryInfo.cancelled", notEqualTo: true)
        // 5
        query.includeKey("deliveryInfo")
        query.includeKey("user")
        // 6
        
        // 7
        
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if let order = object as? Order {
                if order.accepted {
                    self.performSegueWithIdentifier("showCurrentOrder", sender: order)
                } else {
                    self.performSegueWithIdentifier("showWaiting", sender: order)
                    
                    
                }
            }
        }
        
    }

    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        refreshQuery()
        //        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadInRange(range: Range<Int>, completionBlock: ([Delivery]?) -> Void) {
        // 1
        ParseHelper.timelineRequestforCurrentUser(range) {
            (result: [AnyObject]?, error: NSError?) -> Void in
            // 2
            let delivery = result as? [Delivery] ?? []
            // 3
            completionBlock(delivery)
        }
    }
    func refreshQuery() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (point, error) -> Void in
            // 3
            let query = Delivery.query()!
            
            query.whereKey("expiration", greaterThanOrEqualTo: NSDate())
            query.whereKey("cancelled", notEqualTo: true)
            if let point = point {
                //                query.whereKey("location", nearGeoPoint: point)
                query.whereKey("location", nearGeoPoint: point, withinMiles: 5)
            }
            
            // 5
            query.includeKey("user")
            // 6
            query.orderByDescending("createdAt")
            
            // 7
            query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
                // 8
                self.deliveries = result as? [Delivery] ?? []
                // 9
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshQuery()
        
        let install = PFInstallation.currentInstallation()
        
        checkForCurrentDelivery()
//        checkForOrderRequest()
//        checkForPendingOrder()
        
        //        let currentInstallation = PFInstallation.currentInstallation()
        //        currentInstallation.addUniqueObject("Delivery", forKey: "channels")
        //        currentInstallation.saveInBackground()
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)!
            self.selectedDelivery = deliveries[indexPath.row]
        }
        
        if segue.identifier == "makeOrder" {
            if let vc = segue.destinationViewController as? MakeOrderViewController {
                vc.delivery = selectedDelivery
            }
        }
        else if segue.identifier == "profileSegue" {
            if let vc2 = segue.destinationViewController as? ProfileViewController {
                vc2.delivery = delivery
            }
        } else if segue.identifier == "showCurrentDelivery" {
            if let vc = segue.destinationViewController as? DeliveryCreatedViewController, delivery = sender as? Delivery {
                vc.delivery = delivery
            }
        }
        else if segue.identifier == "showWaiting" {
            if let vc = segue.destinationViewController as? WaitingViewController, order = sender as? Order {
                vc.order = order
            }
        }
        else if segue.identifier == "showCurrentOrder" {
            if let vc = segue.destinationViewController as? PickupViewController, order = sender as? Order {
                vc.order = order
            }
        }
        else if segue.identifier == "showOrderRequest" {
            if let vc = segue.destinationViewController as? OrderRequestViewController, order = sender as? Order {
                vc.order = order
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
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
        }()
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return deliveries.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 2
        let cell = tableView.dequeueReusableCellWithIdentifier("DeliveryCell") as! OrderTableViewCell
        
        cell.delivery = deliveries[indexPath.row]
        
        
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    }
}





