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
    @IBOutlet weak var finish: UIButton!
    
    var delivery = Delivery()
    var order : Order?
    
    var deliveries: [Delivery] = []

    @IBAction func deleteOrder(sender: AnyObject) {

        var alert=UIAlertController(title: "Alert 2", message: "Two is awesome too", preferredStyle: UIAlertControllerStyle.Alert);
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
        annotation.title = "Order Location"
        annotation.subtitle = "London"
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
