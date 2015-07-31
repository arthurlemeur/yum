//
//  NavigationController.swift
//  yum
//
//  Created by Arthur Le Meur on 7/31/15.
//  Copyright (c) 2015 Arthur Le Meur. All rights reserved.
//

import Foundation

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor.whiteColor()
        let navBgImage:UIImage = UIImage(named: "BGPic")!
        UINavigationBar.appearance().setBackgroundImage(navBgImage, forBarMetrics: .Default)
     self.navigationBar.translucent = false
        if let font = UIFont(name: "Avenir Next", size: 34) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
        }
    }
}