//
//  TabBarView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TabBarView: UIView {

    @IBOutlet weak var btnHome : UIButton!
    @IBOutlet weak var btnNotification : UIButton!
    @IBOutlet weak var btnSetting : UIButton!
    @IBOutlet weak var btnProfile : UIButton!
    @IBOutlet weak var lblCount : UILabel!

    private static var tabbar : TabBarView? = {
        
        guard let tabbar = TabBarView.viewFromNib(is_ipad: IS_iPad) as? TabBarView else{
            return nil
        }
        
        return tabbar
    }()
    
    static var shared : TabBarView? {
        return tabbar
    }
}

extension TabBarView {
    
    @IBAction func btnTabClicked (sender : UIButton) {
        
        if sender.isSelected {
            return
        }
        
        btnHome.isSelected = false
        btnNotification.isSelected = false
        btnSetting.isSelected = false
        btnProfile.isSelected = false
        sender.isSelected = true
        
        appDelegate.tabbarViewcontroller?.selectedIndex = sender.tag
    }
}
