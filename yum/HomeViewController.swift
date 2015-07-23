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
    
    var delivery = Delivery()

    var selectedDelivery : Delivery?
    
    var deliveries: [Delivery] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 3
        let postsFromThisUser = Delivery.query()
//        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 4
        let query = PFQuery.orQueryWithSubqueries([postsFromThisUser!])
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
        
    let install = PFInstallation.currentInstallation()
        
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





