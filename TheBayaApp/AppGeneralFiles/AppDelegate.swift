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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var tabbarViewcontroller : TabbarViewController?
    var tabbarView : TabBarView?
    
    var loginUser : TblUser?
    
    let window = UIWindow.init(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        Fabric.with([Crashlytics.self])

        FirebaseApp.configure()
        self.configureGoogleAnalytics()
        
        application.registerForRemoteNotifications()
        requestNotificationAuthorization(application: application)
        if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            print("User Info :",userInfo)
        }
        
        self.initRootViewController()
        self.loadCountryList()

        return true
    }

    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            CUserDefaults.set(refreshedToken, forKey: UserDefaultFCMToken)
            CUserDefaults.synchronize()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
      
        let notification = userInfo as? [String : AnyObject]
        
        var message = ""
        var projectName = ""
        
        if let dataDic =  notification!["aps"] as? [String : Any] {
            
            if let key = dataDic["alert"] as? [String : Any] {
                
                if let body = key["body"] as? String {
                    message = body
                }
                
                if let title = key["title"] as? String {
                    projectName = title
                }
            }
        }
        
        
        if let notifyType = notification?.valueForInt(key: "gcm.notification.notifyType") {
            
          switch notifyType {
                
            case NotificationAdmin :
            
                if let notifyID = notification?.valueForInt(key: "gcm.notification.adminNotifyId") {
                    self.getPushNotifyCountForAdminTypeNotification(adminNotifyID: notifyID)
                }
                
                if application.applicationState == .inactive {
                    
                    self.tabbarView?.btnNotification.isSelected = false
                    self.tabbarView?.btnTabClicked(sender: (self.tabbarView?.btnNotification)!)
                    
                } else {
                    self.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = self.topViewController() {
                            
                            if topViewController is NotificationViewController {
                                
                                let notificationVC = topViewController as! NotificationViewController
                                notificationVC.loadNotificationList(isRefresh: false, isFromNotification : true)
                            } else {
                                self.tabbarView?.btnNotification.isSelected = false
                                self.tabbarView?.btnTabClicked(sender: (self.tabbarView?.btnNotification)!)
                            }
                        }
                        
                    }, btnTwoTitle: "cancel", btnTwoTapped: { (action) in
                    })
               }
            
            
            case NotificationNewProject, NotificationProjectComplete :
                
                if application.applicationState == .inactive {
                    
                    if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                        projectDetailVC.projectID =  (notification?.valueForInt(key: "gcm.notification.projectId"))!
                        self.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
                    }
                    
                } else {
                    
                    self.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = self.topViewController() {
                            
                            if topViewController is ProjectDetailViewController {
                            } else {
                                
                                if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                                   projectDetailVC.projectID =  (notification?.valueForInt(key: "gcm.notification.projectId"))!
                                    self.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
                                }
                            }
                        }
                 
                        
                    }, btnTwoTitle: "cancel", btnTwoTapped: { (action) in
                    })
                }
                
                break
                
            case NotificationPostUpdate :
                
                if application.applicationState == .inactive {
                    
                    if let timelineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                        timelineVC.projectID = (notification?.valueForInt(key: "gcm.notification.projectId"))!
                        timelineVC.isFromNotifition = true
                        self.topViewController()?.navigationController?.pushViewController(timelineVC, animated: true)
                    }
                    
                } else {
                   
                    self.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = self.topViewController() {
                            
                            if topViewController is TimelineDetailViewController {
                                
                                let timelineVC  = topViewController as! TimelineDetailViewController
                                timelineVC.projectID = (notification?.valueForInt(key: "gcm.notification.projectId"))!
                                timelineVC.isFromNotifition = true
                                timelineVC.loadSubscribedProjectList(isRefresh: false, isFromNotification: true)
                                
                            } else {
                                
                                if let timelineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                                    timelineVC.projectID = (notification?.valueForInt(key: "gcm.notification.projectId"))!
                                    timelineVC.isFromNotifition = true
                                    self.topViewController()?.navigationController?.pushViewController(timelineVC, animated: true)
                                }
                            }
                        }
                        
                    }, btnTwoTitle: "cancel", btnTwoTapped: { (action) in
                    })
                }
                
                break
        
            case NotificationVisitUpdate, NotificationVisitReschedule, NotificationVisitCancel :
             
                if application.applicationState == .inactive {
                    
                    if let visitDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "VisitDetailsViewController") as? VisitDetailsViewController {
                        self.topViewController()?.navigationController?.pushViewController(visitDetailVC, animated: true)
                    }
                    
                } else {
                    self.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = self.topViewController() {
                            
                            if topViewController is VisitDetailsViewController {
                                
                                let visitDetailVC  = topViewController as! VisitDetailsViewController
                                visitDetailVC.loadVisitList(isRefresh: false, isFromNotification : true)
                                
                            } else {
                                
                                if let visitDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "VisitDetailsViewController") as? VisitDetailsViewController {
                                    self.topViewController()?.navigationController?.pushViewController(visitDetailVC, animated: true)
                                }
                            }
                        }
               
                    }, btnTwoTitle: "cancel", btnTwoTapped: { (action) in
                    })
                }
                
                break
                
            default :
                
                if application.applicationState == .inactive {
                    
                    if let rateVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                        rateVC.visitId = (notification?.valueForInt(key: "gcm.notification.visitId"))!
                        self.topViewController()?.navigationController?.pushViewController(rateVC, animated: true)
                    }
                    
                } else {
                    self.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = self.topViewController() {
                            
                            if topViewController is RateYoorVisitViewController {
                            } else {
                                if let rateVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                                    rateVC.visitId = (notification?.valueForInt(key: "gcm.notification.visitId"))!
                                    self.topViewController()?.navigationController?.pushViewController(rateVC, animated: true)
                                }
                            }
                        }
               
                    }, btnTwoTitle: "cancel", btnTwoTapped: { (action) in
                    })
                }
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
        print("url \(url)")
        print("url host :\(url.host!)")
        print("url path :\(url.path)")

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
                    
                    if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                        projectDetailVC.projectID = Int(projectID)!
                        self.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
                    }
                    
                } else {
                    
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
    
    func logout()
    {
        if CUserDefaults.value(forKey: UserDefaultFCMToken) != nil {
            let fcmToken = CUserDefaults.value(forKey: UserDefaultFCMToken) as! String
            appDelegate.registerDeviceToken(fcmToken: fcmToken, isLoggedIn: 0)
        }
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
    // MARK:- Google Analytics
    
    func configureGoogleAnalytics() {
        
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return
        }
        
        gai.tracker(withTrackingId: CTrackingID)
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
    }
    
    func trackScreenNameForGoogleAnalytics(screenName : String) {
        
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screenName)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func trackCustomEvent(buttonName : String) {
      
//        let tracker = GAI.sharedInstance().defaultTracker
//
//        tracker?.send(GAIDictionaryBuilder.createEvent(withCategory: "Button Interaction", action: "\(buttonName) is clicked", label: "Button Click", value: nil).build() as [NSObject : AnyObject])
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
                
                print("Response :",response)
            }
        }
        
    }
    
    
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
    
    func unreadCount(){
        
        APIRequest.shared().unreadCount { (response, error) in
            
            if response != nil && error == nil {
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]
                
                appDelegate.loginUser?.postBadge = Int16(dataResponse.valueForInt(key: CFavoriteProjectBadge)!)
                CoreData.saveContext()
                
                if dataResponse.valueForInt(key: "unreadCount") == 0 {
                    self.tabbarView?.lblCount.isHidden = true
                } else {
                    self.tabbarView?.lblCount.isHidden = false
                   // self.tabbarView?.lblCount.text = "\(dataResponse.valueForInt(key: "unreadCount") ?? 0)"
                }
            }
        }
    }
}

