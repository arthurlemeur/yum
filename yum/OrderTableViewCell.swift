//
//  OrderTableViewCell.swift
//  yum
//
//  Created by Arthur Le Meur on 7/10/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderButton: UIButton!
    
    // set properties to use in tableview cell
    var delivery : Delivery? {
        didSet{
            username.text = delivery?.user?.username
            restaurant.text = delivery?.restaurant
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            timePicker.text = formatter.stringFromDate(delivery!.deliveryStartTime)
            endTime.text = formatter.stringFromDate(delivery!.endTime)
            
        }
    }
    

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var timePicker: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var goToOrder: UIButton!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
