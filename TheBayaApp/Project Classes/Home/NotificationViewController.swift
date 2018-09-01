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
    
    var arrNotification = [[String : AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        self.title = "Notifications"
        
        arrNotification = [["project_name" : "Baya Victoria", "message" : "Your visit at 5:00 PM has been confirmed.","time" : "Yesterday at 12:00 PM", "isRead" : false, "isRate" : false],
        ["project_name" : "Baya Junction", "message" : "Box filling till 15th floor has been done.","time" : "Yesterday at 12:00 PM", "isRead" : false, "isRate" : false],
        ["project_name" : "Baya Victoria", "message" : "Your visit at 5:00 PM has been confirmed.","time" : "Yesterday at 12:00 PM", "isRead" : true, "isRate" : true],
        ["project_name" : "Baya Victoria", "message" : "Please spare few minutes to rate your visit to The Baya Victoria, Chembur on 20 July 2018 at 5:00 PM","time" : "Yesterday at 12:00 PM", "isRead" : true, "isRate" : false],
        ["project_name" : "Baya Victoria", "message" : "New project from the Baya group.","time" : "Yesterday at 12:00 PM", "isRead" : true, "isRate" : false],
        ["project_name" : "The Baya Group", "message" : "Happy New Year... Best wishes to you on this new year.","time" : "Yesterday at 12:00 PM", "isRead" : true, "isRate" : false],
        ["project_name" : "Baya GoldSpot", "message" : "Your visit at 5:00 PM has been confirmed.","time" : "Yesterday at 12:00 PM", "isRead" : true, "isRate" : false]] as [[String : AnyObject]]
        
        if IS_iPhone {
            tblNotification.estimatedRowHeight = 105
            tblNotification.rowHeight = UITableViewAutomaticDimension
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
            
            cell.lblProjectName.text = dict.valueForString(key: "project_name")
            cell.lblMsg.text = dict.valueForString(key: "message")
            cell.lblDateTime.text = dict.valueForString(key: "time")
 
            if dict.valueForBool(key: "isRate") {
                cell.btnRateVisit.hide(byWidth: false)
            } else {
                cell.btnRateVisit.hide(byWidth: true)
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
