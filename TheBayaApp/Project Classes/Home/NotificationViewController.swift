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

    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    fileprivate var lastPage : Int = 0
    fileprivate var currentPage : Int = 1
    
    var arrNotification = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showTabBar()
        appDelegate.tabbarView?.lblCount.isHidden = true
        self.loadNotificationList(isRefresh: false, isFromNotification :false)
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
        
        
        if IS_iPhone {
            tblNotification.estimatedRowHeight = 105
            tblNotification.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    func getDateTimeFromTimestamp(from interval : TimeInterval, isReschedule : Bool) -> String
    {
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
            cell.btnRateVisit.hide(byWidth: true)
            
            cell.imgVProject.sd_setShowActivityIndicatorView(true)
            cell.imgVProject.sd_setImage(with: URL(string: (dict.valueForString(key: "thumbImage"))), placeholderImage: nil)
            
            
            switch dict.valueForInt(key: "notifyType") {
            case 0 : //... Admin
               cell.lblMsg.text = dict.valueForString(key: "message")
                
           
            case 1:  //... New Project
                 cell.lblMsg.text = "The new project \(dict.valueForString(key: "title")) has been added by The Baya Group."

                break
                
            case 2:  //... Post Update
                cell.lblMsg.text = "There is new update from this project."

                break
                
            case 3: //... Project Complete
                cell.lblMsg.text = "\(dict.valueForString(key: "title")) project is completed now, no further updates will be posted. You can view our other projects and subscribe if you are interested."

                break
                
            case 4: //... Visit Update
                cell.lblMsg.text = "Your visit \(DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: "dateTime")!, withFormate: "'at' hh:mm a 'on' dd MMMM yyyy")) has been confirmed."

                
                break
                
            case 5: //... Visit Reschedule
                cell.lblMsg.text = "Your visit has been re-scheduled from \(self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "dateTime")!,isReschedule : true)) to \(self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "dateTime")!,isReschedule : true))"

                break
             
            case 6 : //... Rate Visit
                cell.lblMsg.text = "Rate the visit scheduled on \(self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "dateTime")!,isReschedule : false))"
                
                cell.btnRateVisit.hide(byWidth: false)
                break
                
            default : //...Cancel Visit
                cell.lblMsg.text = "Your visit scheduled on \(self.getDateTimeFromTimestamp(from: dict.valueForDouble(key: "dateTime")!,isReschedule : true)) has been cancelled"
            }
            
            
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
                    self.navigationController?.pushViewController(rateVisitVC, animated: true)
                }
            }
            
            if indexPath == tblNotification.lastIndexPath() {
                
                //...Load More
                if currentPage < lastPage {
                    
                    if apiTask?.state == URLSessionTask.State.running {
                        self.loadNotificationList(isRefresh: true, isFromNotification :false)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 4 {
            //...New Project
            
            if let projectDetailVC = CStoryboardMain.instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController {
                self.navigationController?.pushViewController(projectDetailVC, animated: true)
            }
        }
    }
}


//MARK:-
//MARK:- API

extension NotificationViewController {
    
    @objc func pullToRefresh(){
        currentPage = 1
        self.refreshControl.beginRefreshing()
        self.loadNotificationList(isRefresh: true, isFromNotification :false)
    }
    
    func loadNotificationList(isRefresh : Bool, isFromNotification : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        if !isRefresh {
            activityLoader.startAnimating()
        }
        
        if isFromNotification {
            currentPage = 1
        }
        
        apiTask = APIRequest.shared().notificationList(page: currentPage, completion: { (response, error) in
            
            self.apiTask?.cancel()
            self.activityLoader.stopAnimating()
            self.refreshControl.endRefreshing()
            
            if response != nil && error == nil {
                
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                
                if self.currentPage == 1 {
                    self.arrNotification.removeAll()
                }
                
                if arrData.count > 0 {
                    
                    for item in arrData {
                        self.arrNotification.append(item)
                    }
                }
                
                self.lastPage = metaData.valueForInt(key: CLastPage)!
                
                if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                    self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                }
                
                self.lblNoData.isHidden = self.arrNotification.count != 0
                self.tblNotification.reloadData()
            }
        })
    }
 
}
