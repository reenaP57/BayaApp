//
//  NotificationViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class NotificationViewController: ParentViewController {

    @IBOutlet fileprivate weak var tblNotification : UITableView!
    @IBOutlet fileprivate weak var activityLoader : UIActivityIndicatorView!
    @IBOutlet fileprivate weak var lblNoData : UILabel!
    @IBOutlet fileprivate weak var imgVBg : UIImageView!

    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    fileprivate var lastPage : Int = 0
    var currentPage : Int = 1
    
    var arrNotification = [[String : AnyObject]]()
    var isFromOtherScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showTabBar()
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CNotificationScreenName)
        appDelegate.tabbarView?.lblCount.isHidden = true
        
        //...Load notification list from server
        self.loadNotificationList(showLoader: false, isFromNotification :isFromOtherScreen)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        self.title = "Notifications"
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        tblNotification?.pullToRefreshControl = refreshControl
        
        //...Load notification list from server
        self.loadNotificationList(showLoader: true, isFromNotification :isFromOtherScreen)
        
        if IS_iPhone {
            tblNotification.estimatedRowHeight = 105
            tblNotification.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    func getDateTimeFromTimestamp(from interval : TimeInterval, isReschedule : Bool) -> String
    {
        //...Get Date and Time from timestamp
        let calendar = NSCalendar.current
        let date = Date(timeIntervalSince1970: interval)
        if calendar.isDateInYesterday(date) {
            return "Yesterday at \(DateFormatter.dateStringFrom(timestamp: interval, withFormate: "hh:mm a"))"
        } else if calendar.isDateInToday(date) {
            return "Today at \(DateFormatter.dateStringFrom(timestamp: interval, withFormate: "hh:mm a"))"
        } else {
            if isReschedule {
                return DateFormatter.dateStringFrom(timestamp: interval, withFormate: "dd MMMM yyyy hh:mm a")
            } else {
                return DateFormatter.dateStringFrom(timestamp: interval, withFormate: "dd MMMM yyyy 'at' hh:mm a")
            }
        }
    }
    
}


//MARK:-
//MARK:- UITableview Delegate and Datsource

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTblCell") as? NotificationTblCell {
            
            let dict = arrNotification[indexPath.row]
            
            cell.lblProjectName.text = dict.valueForString(key: "title")
            cell.lblDateTime.text = self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "dateTime")!,isReschedule : false)
            
            cell.imgVProject.sd_setShowActivityIndicatorView(true)
            cell.imgVProject.sd_setImage(with: URL(string: (dict.valueForString(key: "thumbImage"))), placeholderImage: nil)
        
            cell.lblMsg.text = dict.valueForString(key: "message")
            if dict.valueForInt(key: "notifyType") == NotificationRateVisit {
                 cell.btnRateVisit.hide(byWidth: false)
            } else {
                 cell.btnRateVisit.hide(byWidth: true)
            }
            
            
          /*  switch dict.valueForInt(key: "notifyType") {
            case NotificationAdmin, NotificationNewProject, NotificationPostUpdate, NotificationProjectComplete : //... Admin, New Project, Post Update, Project Complete
               cell.lblMsg.text = dict.valueForString(key: "message")
                
            case  NotificationVisitCancel  : //...Visit Cancel
                cell.lblMsg.text = "Your visit scheduled on \((DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: "dateTime")!, withFormate: "dd MMMM yyyy hh:mm a"))) has been cancelled."
                
            case NotificationVisitUpdate: //... Visit Update
                cell.lblMsg.text = "Your visit \(DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: "dateTime")!, withFormate: "'at' hh:mm a 'on' dd MMMM yyyy")) has been confirmed."
                break
                
            case NotificationVisitReschedule: //... Visit Reschedule
                cell.lblMsg.text = "Your visit has been re-scheduled from \(self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "oldDateTime")!,isReschedule : true)) to \(self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "dateTime")!,isReschedule : true))"
                break
             
            default : //... Rate Visit
                cell.lblMsg.text = "Rate the visit scheduled on \(self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "dateTime")!,isReschedule : false))"
                cell.btnRateVisit.hide(byWidth: false)
                break
            } */
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.vwContent.layer.borderWidth = 1
            
            if dict.valueForBool(key: "isRead") {
                cell.vwContent.layer.borderColor = UIColor.clear.cgColor
                cell.vwContent.backgroundColor = ColorWhite
            } else {
                cell.vwContent.layer.borderColor = ColorGreenSelected.cgColor
                cell.vwContent.backgroundColor = ColorUnreadNotification
            }
            
            cell.btnRateVisit.touchUpInside { (sender) in

                if let rateVisitVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                    rateVisitVC.isVisitRate = true
                    rateVisitVC.visitId = dict.valueForInt(key: "visitId")!
                    self.navigationController?.pushViewController(rateVisitVC, animated: true)
                }
            }
            
            if indexPath == tblNotification.lastIndexPath() {
                
                //...Load More
                if currentPage <= lastPage {
                    
                    if apiTask?.state != URLSessionTask.State.running {
                        self.loadNotificationList(showLoader: false, isFromNotification :false)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = arrNotification[indexPath.row]
        
        switch dict.valueForInt(key: "notifyType") {
        case NotificationPostUpdate:
            //...Post Update
            
            if let timeLineDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "TimelineDetailViewController") as? TimelineDetailViewController {
                timeLineDetailVC.projectID = dict.valueForInt(key: CProjectId)!
                timeLineDetailVC.isFromNotifition = true
                self.navigationController?.pushViewController(timeLineDetailVC, animated: true)
            }
            
        case NotificationNewProject:
            //...New Project
            
            if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                projectDetailVC.projectID = dict.valueForInt(key: CProjectId)!
                self.navigationController?.pushViewController(projectDetailVC, animated: true)
            }
            
        case NotificationVisitUpdate, NotificationVisitCancel, NotificationVisitReschedule:
            //...Visit Update
            
            if let visitDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "VisitDetailsViewController") as? VisitDetailsViewController {
                self.navigationController?.pushViewController(visitDetailVC, animated: true)
            }
           
        case NotificationDocumentUploaded :
            //...My Document uploaded
            
            if let docVC = CStoryboardDocument.instantiateViewController(withIdentifier: "ProjectDocumentViewController") as? ProjectDocumentViewController {
                docVC.isFromMyDoc = true
                self.navigationController?.pushViewController(docVC, animated: true)
            }
            
        case NotificationProjectDocumentUploaded :
            //...Project Document uploaded

            if let docVC = CStoryboardDocument.instantiateViewController(withIdentifier: "ProjectDocumentViewController") as? ProjectDocumentViewController {
                docVC.isFromMyDoc = false
                self.navigationController?.pushViewController(docVC, animated: true)
            }

        case NotificationDemandRequestRaised :
            //...Demand Request Raised
            
            if (appDelegate.loginUser?.isCheckPassword)! {
                if let paymentVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PayementViewController") as? PayementViewController {
                    self.navigationController?.pushViewController(paymentVC, animated: true)
                }
            } else {
                if let paymentVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PaymentScheduleViewController") as? PaymentScheduleViewController {
                    self.navigationController?.pushViewController(paymentVC, animated: true)
                }
            }
            
        case NotificationMaintenanceRequestStatusChange :
            //...Change Maintenance Request Status
            
            if let viewMaintenanceVC = CStoryboardMaintenance.instantiateViewController(withIdentifier: "ViewMaintenanceRequestViewController") as? ViewMaintenanceRequestViewController {
                viewMaintenanceVC.isFromRate = false
                viewMaintenanceVC.requestID = dict.valueForInt(key: "maintenanceRequestId") ?? 0
                self.navigationController?.pushViewController(viewMaintenanceVC, animated: true)
            }
            
        default:
            print("")
        }
    }
}


//MARK:-
//MARK:- API

extension NotificationViewController {
    
    @objc func pullToRefresh(){
        currentPage = 1
        self.refreshControl.beginRefreshing()
        self.loadNotificationList(showLoader: false, isFromNotification :false)
    }
    
    func loadNotificationList(showLoader : Bool, isFromNotification : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
//        if !isRefresh && !isFromNotification {
//            activityLoader.startAnimating()
//        }
        
        if isFromNotification {
            currentPage = 1
        }
        
        apiTask = APIRequest.shared().notificationList(page: currentPage, showLoader: showLoader, completion: { (response, error) in
            
            self.apiTask?.cancel()
        //    self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {
                
                self.imgVBg.isHidden = false
                
                if self.currentPage == 1 {
                    self.arrNotification.removeAll()
                }
                
                if  let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    if arrData.count > 0 {
                        
                        self.arrNotification = self.arrNotification + arrData
//                        for item in arrData {
//                            self.arrNotification.append(item)
//                        }
                    }
                }
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    
                    self.lastPage = metaData.valueForInt(key: CLastPage)!
                    
                    if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                        self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                    }
                }
                
                self.lblNoData.isHidden = self.arrNotification.count != 0
                self.tblNotification.reloadData()
            } else {
                self.imgVBg.isHidden = true
            }
        })
    }
 
}
