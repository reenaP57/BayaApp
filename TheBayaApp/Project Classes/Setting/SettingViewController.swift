//
//  SettingViewController.swift
//  TheBayaApp
//
//  Created by Mac-0008 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SettingViewController: ParentViewController {
    
    @IBOutlet fileprivate weak var tblSettings: UITableView!
    
    let arrSetting = ["Edit Profile", "Change Password", "Notification", "Email Notification","Terms & Conditions", "Privacy Policy", "Support", "About Us", "Rate App", "Logout"]
    
    //MARK:-
    //MARK:- LyfeCycle Methods
    
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
        self.title = "Settings"
        
        if IS_iPad {
            tblSettings.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
            tblSettings.isScrollEnabled = false
        }
    }

}

//MARK:-
//MARK:- Change Notification Status

extension SettingViewController {
    
    @objc func switchChanged(sender: UISwitch) {
        
        let point = sender.convert(sender.bounds.origin, to: tblSettings)
        let indexPath = tblSettings.indexPathForRow(at: point)
        
        //...Notification Swicth
        if indexPath?.row == 2 {
            
            if sender.isOn {
                //...swicth is in on
            } else {
                //...swicth is in off
            }
        }
        
        //...Email Notification Swicth
        if indexPath?.row == 3 {
            
            if sender.isOn {
                //...swicth is in on
            } else {
                //...swicth is in off
            }
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension SettingViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_iPad ? CScreenWidth * (60 / 768) : CScreenWidth * (60 / 375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTblCell") as? SettingTblCell {
            
            cell.lblTitle.text = arrSetting[indexPath.row]
            
            if indexPath.row == 2 || indexPath.row == 3 {
                cell.imgVArrow.isHidden = true
                cell.switchNotify.isHidden = false
            } else {
                cell.imgVArrow.isHidden = false
                cell.switchNotify.isHidden = true
            }

            cell.switchNotify.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            //...Edit Profile
            if  let editProfileVC = CStoryboardSetting.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
      
        case 1:
            //...Change Password
            if let changePwdVC = CStoryboardSetting.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
                self.navigationController?.pushViewController(changePwdVC, animated: true)
            }
     
        case 4,5,7:
            //...Terms & Conditions
            if let cmsVC = CStoryboardSettingIphone.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
               
                if indexPath.row == 4 {
                    cmsVC.cmsEnum = .TermsCondition
                } else if indexPath.row == 5 {
                    cmsVC.cmsEnum = .PrivacyPolicy
                } else {
                    cmsVC.cmsEnum = .AboutUs
                }
   
                self.navigationController?.pushViewController(cmsVC, animated: true)
            }
            
        case 6:
            //...Support
            if let supportVC = CStoryboardSetting.instantiateViewController(withIdentifier: "SupportViewController") as? SupportViewController {
                self.navigationController?.pushViewController(supportVC, animated: true)
            }
            
        case 8:
            //...Rate App
            self.openInSafari(strUrl: "www.google.com")
            break
            
        default:
            //...Logout
            self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CLogOutMessage, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                appDelegate.logout()
            }, btnTwoTitle: CBtnNo) { (action) in
            }
        }
    }
}
