//
//  CurrentCustomerViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/22/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI
class CurrentCustomerViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var customerOrder: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messenger: UIButton!
    
    @IBOutlet weak var deliveryCompleted: UIButton!

    @IBAction func deliveryCompleted(sender: AnyObject) {
        var alert=UIAlertController(title: "Alert 2", message: "Two is awesome too", preferredStyle: UIAlertControllerStyle.Alert);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            if let order = self.order {
                //                    self.order = order
                order.completed = true
                order.saveInBackground()
//                self.popToRootViewControllerAnimated(true)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }));
        presentViewController(alert, animated: true, completion: nil);
        
    }
    
    @IBOutlet weak var picture: UIImageView!
    @IBAction func facebookMessenger(sender: AnyObject) {
        if let fbid = order?.user?.valueForKey("fbid") as? String {
            println(fbid)
            let url = NSURL(string: "fb-messenger://user-thread/\(fbid)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    var orders: [Order] = []
    var order : Order? {
        didSet{
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        username.text = order?.user?.username
        customerOrder.text = order?.orderDetail
        picture.layer.masksToBounds = false
        picture.layer.cornerRadius = picture.frame.height/2
        picture.clipsToBounds = true
        if let urlString = order?.user?["photoLarge"] as? String, url = NSURL(string: urlString) {
            // Add placeholder later
            picture.sd_setImageWithURL(url, placeholderImage: nil)
        }
        // 1
        //        var geoPoint : PFGeoPoint?
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
        annotation.subtitle = ""
        mapView.addAnnotation(annotation)
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
