//
//  CurrentCustomerViewController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/22/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit
import MapKit

class CurrentCustomerViewController: UIViewController {
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var customerOrder: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    

    @IBOutlet weak var messenger: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
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
