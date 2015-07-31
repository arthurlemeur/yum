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
    var selectedDelivery : Delivery?
    
    var deliveries: [Delivery] = []
    
    @IBAction func deleteOrder(sender: AnyObject) {
        order?.deleteInBackgroundWithBlock { (success, error) -> Void in
            if success {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = delivery.user?.username
    
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
