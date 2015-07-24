//
//  Delivery.swift
//  yum
//
//  Created by Arthur Le Meur on 7/13/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import Foundation
import Parse

// 1
class Delivery : PFObject, PFSubclassing {
    
    
    // 2
    @NSManaged var user: PFUser?
    @NSManaged var deliveryFee: NSNumber
    @NSManaged var deliveryStartTime: NSDate
    @NSManaged var restaurant: String
    @NSManaged var location: PFGeoPoint?
    @NSManaged var fbID: String
    


    
    var endTime : NSDate {
        let laterDate = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.CalendarUnitHour,
            value: 1,
            toDate: deliveryStartTime,
            options: NSCalendarOptions.WrapComponents)
      return laterDate!
    }
    
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Delivery"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }


}