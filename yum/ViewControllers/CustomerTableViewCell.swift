//
//  CustomerTableViewCell.swift
//  yum
//
//  Created by Arthur Le Meur on 7/21/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import UIKit

class CustomerTableViewCell: UITableViewCell {

    // set properties to use in tableview cell
    var order : Order? {
        didSet{
            username.text =
                order?.user?.username
            picture.layer.masksToBounds = false
            picture.layer.cornerRadius = picture.frame.height/2
            picture.clipsToBounds = true
            if let urlString = order?.user?["photoLarge"] as? String, url = NSURL(string: urlString) {
                // Add placeholder later
                picture.sd_setImageWithURL(url, placeholderImage: nil)
                if ((order?.pending = true != nil) != nil) {
                    pending.text = "pending"

                }
                else {
                    pending.text = ""
                }
            }
        }
    }
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var pending: UILabel!

    @IBOutlet weak var username: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    

}
