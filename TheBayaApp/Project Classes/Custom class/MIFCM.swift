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
        //...Receive Notification
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
                
            case NotificationAdmin : //...Admin notification
                
                if let notifyID = userInfo.valueForInt(key: "gcm.notification.adminNotifyId") {
                    appDelegate.getPushNotifyCountForAdminTypeNotification(adminNotifyID: notifyID)
                }
                
                if application.applicationState == .inactive {
                    //...In active
                    appDelegate.tabbarView?.btnNotification.isSelected = false
                    appDelegate.tabbarView?.btnTabClicked(sender: (appDelegate.tabbarView?.btnNotification)!)
                    
                } else {
                    //...Active
                    appDelegate.topViewController()?.showAlertConfirmationView("\(projectName)\n\(message)", okTitle: "View", cancleTitle: "cancel", type: .confirmationView, completion: { (result) in
                        
                        if result {
                            if let topViewController = appDelegate.topViewController() {
                                
                                if topViewController is NotificationViewController {
                                    
                                    let notificationVC = topViewController as! NotificationViewController
                                    notificationVC.loadNotificationList(showLoader: false, isFromNotification : true)
                                } else {
                                    appDelegate.tabbarView?.btnNotification.isSelected = false
                                    appDelegate.tabbarView?.btnTabClicked(sender: (appDelegate.tabbarView?.btnNotification)!)
                                }
                            }
                        }
                    })
                }
                
                
            case NotificationNewProject, NotificationProjectComplete : //...New project and Project complete notification
                
                if application.applicationState == .inactive {
                    
                    if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                        projectDetailVC.projectID =  (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                        appDelegate.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
                    }
                    
                } else {
                    
                    appDelegate.topViewController()?.showAlertConfirmationView("\(projectName)\n\(message)", okTitle: "View", cancleTitle: "cancel", type: .confirmationView, completion: { (result) in
                        
                        if result {
                            if let topViewController = appDelegate.topViewController() {
                                
                                if topViewController is ProjectDetailViewController {
                                } else {
                                    
                                    if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                                        projectDetailVC.projectID =  (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                                        appDelegate.topViewController()?.navigationController?.pushViewController(projectDetailVC, animated: true)
                                    }
                                }
                            }
                        }
                    })
                }
                
                break
                
            case NotificationPostUpdate : //...Post Update Notification
                
                if application.applicationState == .inactive {
                    
                    if let timelineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                        timelineVC.projectID = (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                        timelineVC.isFromNotifition = true
                        appDelegate.topViewController()?.navigationController?.pushViewController(timelineVC, animated: true)
                    }
                    
                } else {
                    
                    appDelegate.topViewController()?.showAlertConfirmationView("\(projectName)\n\(message)", okTitle: "View", cancleTitle: "cancel", type: .confirmationView, completion: { (result) in
                        
                        if result {
                            
                            if let topViewController = appDelegate.topViewController() {
                                
                                if topViewController is TimelineDetailViewController {
                                    
                                    let timelineVC  = topViewController as! TimelineDetailViewController
                                    timelineVC.projectID = (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                                    timelineVC.isFromNotifition = true
                                    timelineVC.loadSubscribedProjectList(showLoader: false, isFromNotification: true)
                                    
                                } else {
                                    
                                    if let timelineVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                                        timelineVC.projectID = (userInfo.valueForInt(key: "gcm.notification.projectId"))!
                                        timelineVC.isFromNotifition = true
                                        appDelegate.topViewController()?.navigationController?.pushViewController(timelineVC, animated: true)
                                    }
                                }
                            }
                        }
                    })
                }
                
                break
                
            case NotificationVisitUpdate, NotificationVisitReschedule, NotificationVisitCancel :
                //Visit update, Visit reschedule and visit cancel Notification
                
                if application.applicationState == .inactive {
                    
                    if let visitDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "VisitDetailsViewController") as? VisitDetailsViewController {
                        appDelegate.topViewController()?.navigationController?.pushViewController(visitDetailVC, animated: true)
                    }
                    
                } else {
                    
                    appDelegate.topViewController()?.showAlertConfirmationView("\(projectName)\n\(message)", okTitle: "View", cancleTitle: "cancel", type: .confirmationView, completion: { (result) in
                        
                        if result {
                            
                            if let topViewController = appDelegate.topViewController() {
                                
                                if topViewController is VisitDetailsViewController {
                                    
                                    let visitDetailVC  = topViewController as! VisitDetailsViewController
                                    visitDetailVC.loadVisitList(showLoader: false, isFromNotification : true)
                                    
                                } else {
                                    
                                    if let visitDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "VisitDetailsViewController") as? VisitDetailsViewController {
                                        appDelegate.topViewController()?.navigationController?.pushViewController(visitDetailVC, animated: true)
                                    }
                                }
                            }
                        }
                    })
                }
                
                break
                
            default : // Rate Visit Notification
                
                if application.applicationState == .inactive {
                    
                    if let rateVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                        rateVC.visitId = (userInfo.valueForInt(key: "gcm.notification.visitId"))!
                        appDelegate.topViewController()?.navigationController?.pushViewController(rateVC, animated: true)
                    }
                    
                } else {
                    
                    appDelegate.topViewController()?.showAlertConfirmationView("\(projectName)\n\(message)", okTitle: "View", cancleTitle: "cancel", type: .confirmationView, completion: { (result) in
                        
                        if result {
                            
                            if let topViewController = appDelegate.topViewController() {
                                
                                if topViewController is RateYoorVisitViewController {
                                } else {
                                    if let rateVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                                        rateVC.visitId = (userInfo.valueForInt(key: "gcm.notification.visitId"))!
                                        appDelegate.topViewController()?.navigationController?.pushViewController(rateVC, animated: true)
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
}
