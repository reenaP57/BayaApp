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
import Firebase
import FirebaseInstanceID
import UserNotifications
import DeviceGuru

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var tabbarViewcontroller : TabbarViewController?
    var tabbarView : TabBarView?
    
    var loginUser : TblUser?
    var deviceName = ""
    
    let window = UIWindow.init(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        appDelegate.window.backgroundColor = ColorBGColor
        IQKeyboardManager.shared.enable = true
        
        //...Fabric configuration
        Fabric.with([Crashlytics.self])

        //...Firebase configuration
        FirebaseApp.configure()
        
        //...Google analytics configuration
        MIGoogleAnalytics.shared().configureGoogleAnalytics()
        
        //...Register remote notification
        application.registerForRemoteNotifications()
        MIFCM.shared().requestNotificationAuthorization(application: application)

        //...Get device name
        let deviceGuru = DeviceGuru()
        deviceName = "\(deviceGuru.hardware())"
        
        self.initRootViewController()
        self.loadCountryList()

        return true
    }

    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //...Get FCM token
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                CUserDefaults.set(result.token, forKey: UserDefaultFCMToken)
                CUserDefaults.synchronize()
                print("Remote instance ID token: \(result.token)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        MIFCM.shared().didReceiveNotification(userInfo: userInfo as! [String : AnyObject], application : application)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        //...Deep Linking redirection
        
        let url = url.absoluteString
        let arrUrl = url.components(separatedBy: "/")
        
        if arrUrl.count > 0 {
            
            let title = arrUrl[2]
            let projectID = arrUrl[3]
            
            if (CUserDefaults.value(forKey: UserDefaultLoginUserToken)) == nil {
                //...Login screen
                self.initLoginViewController()
                
            } else {
                
                if title == "project_detail" {
                    //...Project detail
                    if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                        projectDetailVC.projectID = Int(projectID)!
                        self.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
                    }
                    
                } else {
                    //...Timeline
                    if let timelineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                        timelineVC.projectID = Int(projectID)!
                        timelineVC.isFromNotifition = true
                        self.topViewController()?.navigationController?.pushViewController(timelineVC, animated: true)
                    }
                }
            }
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if IS_iPad {
            if self.topViewController() is ProjectDetailViewController {
                self.hideTabBar()
                appDelegate.tabbarView?.CViewSetHeight(height: 49.0)
            } else {
                GCDMainThread.async {
                    appDelegate.tabbarView?.frame = CGRect(x: 0, y: CScreenHeight - 49.0 - (IS_iPhone_X ? 34.0 : 0.0), width: CScreenWidth, height: 49.0)
                }
            }
        }
    }
    
    
    // MARK:-
    // MARK:- General Methods
    
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    
    func initRootViewController() {
        
        if (CUserDefaults.value(forKey: UserDefaultFirstTimeLaunch)) != nil {
          
            if (CUserDefaults.value(forKey: UserDefaultLoginUserToken)) != nil && (CUserDefaults.string(forKey: UserDefaultLoginUserToken)) != "" && (CUserDefaults.value(forKey: UserDefaultRememberMe)) != nil  {
                
                loginUser =  TblUser.findOrCreate(dictionary: ["user_id" : CUserDefaults.object(forKey: UserDefaultLoginUserID) as Any]) as? TblUser
                self.unreadCount()
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
    
    func logout(isForDeleteUser : Bool)
    {
        if isForDeleteUser || IS_SIMULATOR {
            
            self.tabbarViewcontroller = nil
            self.tabbarView = nil
            
            appDelegate.loginUser = nil
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
            CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
            CUserDefaults.synchronize()
            
            self.initLoginViewController()
            
        } else {
            if CUserDefaults.value(forKey: UserDefaultFCMToken) != nil {
                let fcmToken = CUserDefaults.value(forKey: UserDefaultFCMToken) as! String
                appDelegate.registerDeviceToken(fcmToken: fcmToken, isLoggedIn: 0)
            }
        }
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
    
    func registerDeviceToken(fcmToken : String, isLoggedIn : Int?) {
        
        APIRequest.shared().registerDeviceToken(isLoggedIn: isLoggedIn, token: fcmToken) { (response, error) in
            
            if response != nil && error == nil {
                
                if isLoggedIn == 0 {
                    //...Log out
                    
                    self.tabbarViewcontroller = nil
                    self.tabbarView = nil
                    
                    appDelegate.loginUser = nil
                    CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
                    CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
                    CUserDefaults.synchronize()
                    
                    self.initLoginViewController()
                }
                print("Response :",response as Any)
            }
        }
    }
    
    func getPushNotifyCountForAdminTypeNotification(adminNotifyID : Int) {
        
        APIRequest.shared().pushNotifiyCount(adminNotifyId: adminNotifyID) { (response, error) in
            if response != nil && error == nil {
            }
        }
    }
    
    
    func loadCountryList(){
        
        //...Load country list from server
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
    
    func unreadCount(){
        //...Get unread notification count
        APIRequest.shared().unreadCount { (response, error) in
            
            if response != nil && error == nil {
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                appDelegate.loginUser?.postBadge = Int16(dataResponse.valueForInt(key: CFavoriteProjectBadge)!)
                CoreData.saveContext()
                
                if dataResponse.valueForInt(key: "unreadCount") == 0 {
                    self.tabbarView?.lblCount.isHidden = true
                } else {
                    self.tabbarView?.lblCount.isHidden = false
                }
            }
        }
    }
}

