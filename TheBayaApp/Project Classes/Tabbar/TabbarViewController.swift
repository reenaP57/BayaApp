//
//  TabbarViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTabbarView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TabbarViewController {
    
    func setUpTabbarView() {
        
        self.tabBar.isHidden = true
        
        
        guard let tabbar = TabBarView.shared else { return }
        tabbar.frame = CGRect(x: 0, y: CScreenHeight - 49.0 - (IS_iPhone_X ? 34.0 : 0.0), width: CScreenWidth, height: 49.0)
        
        tabbar.btnHome.isSelected = true
        tabbar.btnNotification.isSelected = false
        tabbar.btnSetting.isSelected = false
        tabbar.btnProfile.isSelected = false
        
        tabbar.lblCount.layer.cornerRadius = tabbar.lblCount.CViewHeight/2
        tabbar.lblCount.layer.masksToBounds = true
        
        appDelegate.tabbarView = tabbar
        self.view.addSubview(tabbar)
        
        
        guard let homeVC = CStoryboardMain.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        let homeNav = UINavigationController.rootViewController(viewController: homeVC)
        

        guard let notificationVC = CStoryboardMain.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController else { return }
        let notificationNav = UINavigationController.rootViewController(viewController: notificationVC)

        guard let settingVC = CStoryboardSetting.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController else { return }
        let settingNav = UINavigationController.rootViewController(viewController: settingVC)

       guard let profileVC = CStoryboardProfile.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
       let profileNav = UINavigationController.rootViewController(viewController: profileVC)
        
  
        self.setViewControllers([homeNav, notificationNav, settingNav, profileNav], animated: true)
    }
    
}
