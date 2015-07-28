//
//  OrderRequestViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/24/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import MapKit

class OrderRequestViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var username2: UILabel!
    @IBOutlet weak var username3: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var orderText: UILabel!
    @IBOutlet weak var accept: UIButton!
    @IBOutlet weak var reject: UIButton!
    var order : Order?
    @IBAction func acceptOrder(sender: AnyObject) {
        //fetch PFObject order (segue for example)
        if let order = order {
            println(order.objectId)
            order.accepted = true
            println(order.accepted)
            order.saveInBackground()
            //send a push notification that the order is accepted
        }
        performSegueWithIdentifier("goToDelivery", sender: nil)

    }
    
    @IBAction func rejectOrder(sender: AnyObject) {
        if let order = order {
            order.accepted = false
            order.save()
        }
        performSegueWithIdentifier("goToDelivery", sender: nil)

        //send a push notification that the order is rejected

    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
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
