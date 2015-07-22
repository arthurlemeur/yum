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
            username.text = order?.user?.username
        }
    }
    
    
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
