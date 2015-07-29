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
    
    var selectedDelivery : Delivery?
    
    var deliveries: [Delivery] = []

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
