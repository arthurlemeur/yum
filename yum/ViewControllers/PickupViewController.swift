//
//  PickupViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/27/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import Parse
import MapKit

class PickupViewController: UIViewController {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messenger: UIButton!
    @IBOutlet weak var finish: UIButton! // \(fbid) //fb-messenger://user-thread/\(fbid)
    @IBAction func messenger(sender: AnyObject) {
        if let fbid = delivery.user?.valueForKey("fbid") as? String {
            println(fbid)
            println("fb-messenger://user-thread/\(fbid)")
            let url = NSURL(string: "https://facebook.com/\(fbid)")
            UIApplication.sharedApplication().openURL(url!)
        }
        else {
            let alertController = UIAlertController(title: "Facebook Messenger Missing", message:
                "Please install facebook messenger", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    var window: UIWindow?
    
    var delivery = Delivery()
    var order : Order?
    
    var deliveries: [Delivery] = []
    
    @IBAction func deleteOrder(sender: AnyObject) {
        
        var alert=UIAlertController(title: "Finish Order?", message: "Your rating will go down if you cancel your order before receiving your food.", preferredStyle: UIAlertControllerStyle.Alert);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) in
            if let order = self.order {
                //                    self.order = order
                order.completed = true
                order.saveInBackground()
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }));
        presentViewController(alert, animated: true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let order = order, delivery = order.deliveryInfo {
            self.delivery = delivery
        }

        picture.layer.masksToBounds = false
        picture.layer.cornerRadius = picture.frame.height/2
        picture.clipsToBounds = true
        if let urlString = delivery.user?["photoLarge"] as? String, url = NSURL(string: urlString) {
            // Add placeholder later
            picture.sd_setImageWithURL(url, placeholderImage: nil)
        }
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.setLeftBarButtonItem(nil, animated: false)
        username.text = delivery.user?.username
        let location = CLLocationCoordinate2D(
            latitude: delivery.location?.latitude ?? 0.0,
            longitude: delivery.location?.longitude ?? 0.0
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // Do any additional setup after loading the view.
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Delivery Location"
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
