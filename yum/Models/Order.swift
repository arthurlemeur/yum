//
//  Order.swift
//  yum
//
//  Created by Arthur Le Meur on 7/21/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import Foundation
import Parse


class Order : PFObject, PFSubclassing {
    
    
    // 2
    @NSManaged var user: PFUser?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var userPhoto: PFFile
    @NSManaged var orderDetail: String
    @NSManaged var deliveryInfo: Delivery?
    @NSManaged var accepted: Bool
    @NSManaged var completed: Bool
    @NSManaged var cancelled: Bool
    
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Order"
    }
    
    // 4
    override init () {
        super.init()
    }
    
//    override class func initialize() {
//        var onceToken : dispatch_once_t = 0;
//        dispatch_once(&onceToken) {
//            // inform Parse about this subclass
//            self.registerSubclass()
//        }
//    }
    
    
}