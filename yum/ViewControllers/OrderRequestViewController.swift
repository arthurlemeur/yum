//
//  OrderRequestViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/24/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI

class OrderRequestViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var username2: UILabel!
    @IBOutlet weak var username3: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var orderText: UILabel!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var reject: UIButton!
    var order : Order?
    var orders: [Order] = []
    var delivery: Delivery?

    @IBAction func acceptOrder(sender: AnyObject) {
        //fetch PFObject order (segue for example)
        if let order = order, let delivery = order.deliveryInfo {
            self.delivery = delivery
            println(order.objectId)
            order.accepted = true
            println(order.accepted)
            order.saveInBackground()
            //send a push notification that the order is accepted
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                self.delivery?.location = geoPoint
                self.delivery?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    if (success) {
                        //self.navigationController?.popViewControllerAnimated(true)
                        // set up notifications
                        if let deliverer = order.user, deliveryID = self.delivery?.objectId, pushQuery = PFInstallation.query(), username = deliverer.username {
                            pushQuery.whereKey("user", equalTo: deliverer)
                            
                            let data = [
                                "alert" : "\(username) has accepted your order!",
                                "deliveryID" : deliveryID
                            ]
                            // Send push notification to query
                            let push = PFPush()
                            push.setQuery(pushQuery) // Set our Installation query
                            push.setData(data)
                            //                        push.setMessage("\(username) wants food!")
                            push.sendPushInBackground()
                        }
                        
                        self.performSegueWithIdentifier("goToDelivery", sender: nil)
                        
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                }
                
            }
        }

    }
    
    @IBAction func rejectOrder(sender: AnyObject) {
        if let order = order {
            order.accepted = false
           order.saveInBackground()
            
                        //self.navigationController?.popViewControllerAnimated(true)
                        // set up notifications
            if let deliverer = self.delivery?.user, deliveryID = self.delivery?.objectId, pushQuery = PFInstallation.query(), username = deliverer.username {
                pushQuery.whereKey("user", equalTo: deliverer)

                            
                            let data = [
                                "alert" : "\(username) has rejected your order :(",
                                "deliveryID" : deliveryID
                            ]
                            // Send push notification to query
                            let push = PFPush()
                            push.setQuery(pushQuery) // Set our Installation query
                            push.setData(data)
                            //                        push.setMessage("\(username) wants food!")
                            push.sendPushInBackground()
                        }
                        
                        self.performSegueWithIdentifier("orderRejected", sender: nil)
                        
                        // The object has been saved.

        }
        performSegueWithIdentifier("goToDelivery", sender: nil)

        //send a push notification that the order is rejected

    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let order = order {
            username.text = order.user?.username
            username2.text = order.user?.username
            username3.text = order.user?.username
            orderText.text = order.orderDetail
        }
        let location = CLLocationCoordinate2D(
            latitude: order?.location?.latitude ?? 0.0,
            
            longitude: order?.location?.longitude ?? 0.0
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Order Location"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDelivery" {
            if let vc = segue.destinationViewController as? DeliveryCreatedViewController {
                vc.delivery = order?["deliveryInfo"] as? Delivery
            }
        }
    }


}
