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
    @IBOutlet weak var picture: UIImageView!
    var order : Order?
    var orders: [Order] = []
    var delivery: Delivery?
    
    @IBAction func acceptOrder(sender: AnyObject) {
        //fetch PFObject order (segue for example)
        if let order = order, let delivery = order.deliveryInfo {
            self.delivery = delivery
            order.accepted = true
            order.pending = false
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
                        if let orderer = order.user, deliveryID = self.delivery?.objectId, pushQuery = PFInstallation.query(), username = order.deliveryInfo?.user?.username {
                            pushQuery.whereKey("user", equalTo: orderer)
                            
                            let data = [
                                "alert" : "\(username) has accepted your order!",
                                "deliveryID" : deliveryID,
                                "orderID" : order.objectId!,
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
        //fetch PFObject order (segue for example)
        if let order = order, let delivery = order.deliveryInfo {
            self.delivery = delivery
            order.accepted = false
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
                        if let orderer = order.user, deliveryID = self.delivery?.objectId, pushQuery = PFInstallation.query(), username = order.deliveryInfo?.user?.username {
                            pushQuery.whereKey("user", equalTo: orderer)
                            
                            let data = [
                                "alert" : "\(username) has accepted your order!",
                                "deliveryID" : deliveryID,
                                "orderID" : order.objectId!,
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


        
        //send a push notification that the order is rejected
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setLeftBarButtonItem(nil, animated: false)
        
        if let order = order {
            username.text = "\(order.user!.username!) wants food!"
            username2.text = order.user!.username!
            username3.text = "\(order.user!.username!)'s order:"
            orderText.text = order.orderDetail
            picture.layer.masksToBounds = false
            picture.layer.cornerRadius = picture.frame.height/2
            picture.clipsToBounds = true
            if let urlString = delivery?.user?["photoLarge"] as? String, url = NSURL(string: urlString) {
                // Add placeholder later
                picture.sd_setImageWithURL(url, placeholderImage: nil)
                let location = CLLocationCoordinate2D(
                    latitude: order.location?.latitude ?? 0.0,
                    longitude: order.location?.longitude ?? 0.0
                )
                // 2
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView.setRegion(region, animated: true)
                
                // Do any additional setup after loading the view.
                //3
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = "Order Location"
                annotation.subtitle = "London"
                mapView.addAnnotation(annotation)
            }
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
