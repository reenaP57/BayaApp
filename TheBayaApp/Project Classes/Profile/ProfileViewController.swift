//
//  ProfileViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProfileViewController: ParentViewController {

    @IBOutlet fileprivate weak var lblName : UILabel!
    @IBOutlet fileprivate weak var lblEmail : UILabel!
    @IBOutlet fileprivate weak var lblMobileNo : UILabel!
    @IBOutlet fileprivate weak var tblList : UITableView!

    let arrList = [["img" : "schedule_profile", "title": "Schedule a Visit"],
                   ["img" : "my_projects_profile", "title": "My Subscribed Projects"],
                   ["img" : "visit_details_profile", "title": "Visit Details"]]
    
  
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
        self.title = "My Profile"
    }
}


//MARK:-
//MARK:- Action

extension ProfileViewController {
    
    @IBAction func btnEditProfileClicked (sender : UIButton) {
        
        if  let editProfileVC = CStoryboardSetting.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
}

//MARK:-
//MARK:- UITableView Delegate and Datasource

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CScreenWidth * (74 / 375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblCell") as? ProfileTblCell {
            
            let dict = arrList[indexPath.row]
            cell.lblTitle.text = dict.valueForString(key: "title")
            cell.imgVTitle.image = UIImage(named: dict.valueForString(key: "img"))
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            //...Schedule a Visit
            if  let scheduleVisitVC = CStoryboardMain.instantiateViewController(withIdentifier: "ScheduleVisitViewController") as? ScheduleVisitViewController {
                self.navigationController?.pushViewController(scheduleVisitVC, animated: true)
            }
            
        case 1:
            //...My Subscribed Projects
            if let subscribedVC = CStoryboardProfile.instantiateViewController(withIdentifier: "SubscribedProjectViewController") as? SubscribedProjectViewController {
                self.navigationController?.pushViewController(subscribedVC, animated: true)
            }
            
        default:
            //...Visit Details
            
            if let visitDetailVC = CStoryboardProfile.instantiateViewController(withIdentifier: "VisitDetailsViewController") as? VisitDetailsViewController {
                self.navigationController?.pushViewController(visitDetailVC, animated: true)
            }
            
        }
    }
}
