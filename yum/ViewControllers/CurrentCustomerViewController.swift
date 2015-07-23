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
    
    var orders: [Order] = []
    var order : Order? {
        didSet{
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        username.text = order?.user?.username
        customerOrder.text = order?.orderDetail
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
