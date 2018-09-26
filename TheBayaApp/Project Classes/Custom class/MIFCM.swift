//
//  MIFCM.swift
//  TheBayaApp
//
//  Created by mac-00017 on 24/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation
import Firebase
import FirebaseInstanceID
import UserNotifications

class MIFCM: NSObject, UNUserNotificationCenterDelegate {
    
    private static var fcm : MIFCM = {
        let fcm = MIFCM()
        return fcm
    }()
    
    static func shared() -> MIFCM {
        return fcm
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
    
    func didReceiveNotification(userInfo : [String : AnyObject], application : UIApplication) {
        
        print(userInfo)
        
        var message = ""
        var projectName = ""
        
        if let dataDic =  userInfo["aps"] as? [String : Any] {
            
            if let key = dataDic["alert"] as? [String : Any] {
                
                if let body = key["body"] as? String {
                    message = body
                }
                
                if let title = key["title"] as? String {
                    projectName = title
                }
            }
        }
        
        
        if let notifyType = userInfo.valueForInt(key: "gcm.notification.notifyType") {
            
            switch notifyType {
                
            case NotificationAdmin :
                
                if let notifyID = userInfo.valueForInt(key: "gcm.notification.adminNotifyId") {
                    appDelegate.getPushNotifyCountForAdminTypeNotification(adminNotifyID: notifyID)
                }
                
                if application.applicationState == .inactive {
                    
                    appDelegate.tabbarView?.btnNotification.isSelected = false
                    appDelegate.tabbarView?.btnTabClicked(sender: (appDelegate.tabbarView?.btnNotification)!)
                    
                } else {
                    appDelegate.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = appDelegate.topViewController() {
                            
                            if topViewController is NotificationViewController {
                                
                                let notificationVC = topViewController as! NotificationViewController
                                notificationVC.loadNotificationList(isRefresh: false, isFromNotification : true)
                            } else {
                                appDelegate.tabbarView?.btnNotification.isSelected = false
                                appDelegate.tabbarView?.btnTabClicked(sender: (appDelegate.tabbarView?.btnNotification)!)
                            }
                        }
                        
                    }, btnTwoTitle: "cancel", btnTwoTapped: { (action) in
                    })
                }
                
                
            case NotificationNewProject, NotificationProjectComplete :
                
                if application.applicationState == .inactive {
                    
                    if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                        projectDetailVC.projectID =  (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                        appDelegate.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
                    }
                    
                } else {
                    
                    appDelegate.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = appDelegate.topViewController() {
                            
                            if topViewController is ProjectDetailViewController {
                            } else {
                                
                                if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                                    projectDetailVC.projectID =  (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                                    appDelegate.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
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
                        timelineVC.projectID = (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                        timelineVC.isFromNotifition = true
                        appDelegate.topViewController()?.navigationController?.pushViewController(timelineVC, animated: true)
                    }
                    
                } else {
                    
                    appDelegate.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = appDelegate.topViewController() {
                            
                            if topViewController is TimelineDetailViewController {
                                
                                let timelineVC  = topViewController as! TimelineDetailViewController
                                timelineVC.projectID = (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                                timelineVC.isFromNotifition = true
                                timelineVC.loadSubscribedProjectList(isRefresh: false, isFromNotification: true)
                                
                            } else {
                                
                                if let timelineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                                    timelineVC.projectID = (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                                    timelineVC.isFromNotifition = true
                                    appDelegate.topViewController()?.navigationController?.pushViewController(timelineVC, animated: true)
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
                        appDelegate.topViewController()?.navigationController?.pushViewController(visitDetailVC, animated: true)
                    }
                    
                } else {
                    appDelegate.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = appDelegate.topViewController() {
                            
                            if topViewController is VisitDetailsViewController {
                                
                                let visitDetailVC  = topViewController as! VisitDetailsViewController
                                visitDetailVC.loadVisitList(isRefresh: false, isFromNotification : true)
                                
                            } else {
                                
                                if let visitDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "VisitDetailsViewController") as? VisitDetailsViewController {
                                    appDelegate.topViewController()?.navigationController?.pushViewController(visitDetailVC, animated: true)
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
                        rateVC.visitId = (userInfo.valueForInt(key: "gcm.notification.visitId"))!
                        appDelegate.topViewController()?.navigationController?.pushViewController(rateVC, animated: true)
                    }
                    
                } else {
                    appDelegate.topViewController()?.presentAlertViewWithTwoButtons(alertTitle: projectName, alertMessage: message, btnOneTitle: "View", btnOneTapped: { (action) in
                        
                        if let topViewController = appDelegate.topViewController() {
                            
                            if topViewController is RateYoorVisitViewController {
                            } else {
                                if let rateVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                                    rateVC.visitId = (userInfo.valueForInt(key: "gcm.notification.visitId"))!
                                    appDelegate.topViewController()?.navigationController?.pushViewController(rateVC, animated: true)
                                }
                            }
                        }
                        
                    }, btnTwoTitle: "cancel", btnTwoTapped: { (action) in
                    })
                }
            }
        }
    }
}
