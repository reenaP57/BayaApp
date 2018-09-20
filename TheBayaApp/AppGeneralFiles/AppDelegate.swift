//
//  AppDelegate.swift
//  TheBayaApp
//
//  Created by mac-0005 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var tabbarViewcontroller : TabbarViewController?
    var tabbarView : TabBarView?
    
    var loginUser : TblUser?
    
    let window = UIWindow.init(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        Fabric.with([Crashlytics.self])
        
        self.initRootViewController()
        self.loadCountryList()

        return true
    }

  
    func initRootViewController() {
        
        if (CUserDefaults.value(forKey: UserDefaultFirstTimeLaunch)) != nil {
            
            if (CUserDefaults.value(forKey: UserDefaultLoginUserToken)) != nil && (CUserDefaults.string(forKey: UserDefaultLoginUserToken)) != "" && (CUserDefaults.value(forKey: UserDefaultRememberMe)) != nil {
                 loginUser =  TblUser.findOrCreate(dictionary: ["user_id" : CUserDefaults.object(forKey: UserDefaultLoginUserID) as Any]) as? TblUser
                 self.initHomeViewController()
            } else {
                self.initLoginViewController()
            }
    
        } else {
            self.initTutorailViewController()
        }
        
        self.window.makeKeyAndVisible()
    }
    
    func initTutorailViewController() {
        let rootVC = UINavigationController.init(rootViewController: CStoryboardLRF.instantiateViewController(withIdentifier: "TutorialViewController"))
        self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
    }
    
    func initLoginViewController() {
        let rootVC = UINavigationController.init(rootViewController: CStoryboardLRF.instantiateViewController(withIdentifier: "LoginViewController"))
        CUserDefaults.set(true, forKey: UserDefaultFirstTimeLaunch)

        self.setWindowRootViewController(rootVC: rootVC, animated: false, completion: nil)
    }
    
    func initHomeViewController() {
        appDelegate.tabbarViewcontroller = TabbarViewController.initWithNibName() as? TabbarViewController
        appDelegate.setWindowRootViewController(rootVC: appDelegate.tabbarViewcontroller, animated: true, completion: nil)
    }
    

    
    func hideTabBar() {
        appDelegate.tabbarView?.CViewSetY(y: CScreenHeight)
    }
    
    func showTabBar() {
        appDelegate.tabbarView?.CViewSetY(y: CScreenHeight - 49.0 - (IS_iPhone_X ? 34.0 : 0.0))
    }
    
    func logout()
    {
        tabbarViewcontroller = nil
        tabbarView = nil

        appDelegate.loginUser = nil
        CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
        CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
        CUserDefaults.synchronize()
        
        self.initLoginViewController()
    }
    
    func setProgressGradient(frame : CGRect) -> UIImage {
       
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ColorProgressGradient1.cgColor,ColorProgressGradient2.cgColor]
        gradientLayer.frame = frame
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.0)
        
        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0.0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    // MARK:-
    // MARK:- Root update
    
    func setWindowRootViewController(rootVC:UIViewController?, animated:Bool, completion: ((Bool) -> Void)?) {
        
        guard rootVC != nil else {
            return
        }
        
        UIView.transition(with: self.window, duration: animated ? 0.6 : 0.0, options: .transitionCrossDissolve, animations: {
            
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            
            self.window.rootViewController = rootVC
            UIView.setAnimationsEnabled(oldState)
        }) { (finished) in
            if let handler = completion {
                handler(true)
            }
        }
    }
    
    
    // MARK:-
    // MARK:- API
    
    func loadCountryList(){
        
        var timestamp : TimeInterval = 0
        
        if CUserDefaults.value(forKey: UserDefaultTimestamp) != nil {
            timestamp = CUserDefaults.value(forKey: UserDefaultTimestamp) as! TimeInterval
        }
        
        APIRequest.shared().getCountryList(_timestamp: timestamp as AnyObject, completion: { (response, error) in
            
            if response != nil && error == nil {
                
                let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject]
                
                CUserDefaults.setValue(metaData?["new_timestamp"], forKey: UserDefaultTimestamp)
                CUserDefaults.synchronize()
            }
        })
    }
}

