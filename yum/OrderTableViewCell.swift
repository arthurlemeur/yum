//
//  OrderTableViewCell.swift
//  yum
//
//  Created by Arthur Le Meur on 7/10/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    
    // set properties to use in tableview cell
    var delivery : Delivery? {
        didSet{
            username.text = delivery?.user?.username
            restaurant.text = delivery?.restaurant
            let formatter = NSDateFormatter()
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            timePicker.text = formatter.stringFromDate(delivery!.deliveryStartTime)
            endTime.text = formatter.stringFromDate(delivery!.endTime)
           picture.layer.masksToBounds = false
            picture.layer.cornerRadius = picture.frame.height/2
            picture.clipsToBounds = true
            if let urlString = delivery?.user?["photoLarge"] as? String, url = NSURL(string: urlString) {
                // Add placeholder later
                picture.sd_setImageWithURL(url, placeholderImage: nil)
            }
        }
    }
    

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var restaurant: UILabel!
    @IBOutlet weak var timePicker: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    

   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
