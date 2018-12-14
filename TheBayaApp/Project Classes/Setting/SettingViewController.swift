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
    @IBOutlet fileprivate weak var imgVBg: UIImageView!
    var arrSetting =  [String]()
   
    //MARK:-
    //MARK:- LyfeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CSettingScreenName)
        appDelegate.showTabBar()
        
        //...Load user detail from server
        self.userDetail()
        self.initialize()
        self.tblSettings.reloadData()
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
        }
        
        //...If visiblePaymentSection=1 that time payment password will be show otherwise it will be hide
        if (appDelegate.loginUser?.visiblePaymentSection)! {
           arrSetting = [CEditProfile, CChangePassword, CPushNotifications, CEmailNotifications, CSMSNotifications, CPaymentPassword, CTermsConditions, CPrivacyPolicy, CAppSupport, CAboutUs, CRateApp, CLogout]
        } else {
           arrSetting = [CEditProfile, CChangePassword, CPushNotifications, CEmailNotifications, CSMSNotifications, CTermsConditions, CPrivacyPolicy, CAppSupport, CAboutUs, CRateApp, CLogout]
        }
    }

}

//MARK:-
//MARK:- Change Notification Status

extension SettingViewController {
    
    @objc func switchChanged(sender: UISwitch) {
        
        let point = sender.convert(sender.bounds.origin, to: tblSettings)
        let indexPath = tblSettings.indexPathForRow(at: point)
        
        
        switch arrSetting[(indexPath?.row)!] {
        case CPushNotifications:  //...Push Notification Switch
            if sender.isOn {
                //...switch is in on
                
                self.showAlertConfirmationView(CEnablePushNotificationMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                    if result {
                        sender.isOn = true
                        self.changeNotificationStatus(email: (appDelegate.loginUser?.emailNotify)! ? "1" : "0", push: "1", sms: (appDelegate.loginUser?.smsNotify)! ? "1" : "0")
                    } else {
                        sender.isOn = false
                    }
                }
                
            } else {
                //...switch is in off
                
                self.showAlertConfirmationView(CDisablePushNotificationMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                    if result {
                        sender.isOn = false
                        self.changeNotificationStatus(email: (appDelegate.loginUser?.emailNotify)! ? "1" : "0", push: "0", sms: (appDelegate.loginUser?.smsNotify)! ? "1" : "0")
                    } else {
                        sender.isOn = true
                    }
                }
            }
          
        case CEmailNotifications: //...Email Notification Switch
            if sender.isOn {
                //...switch is in on
                
                self.showAlertConfirmationView(CEnableEmailNotificationMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                    if result {
                        sender.isOn = true
                        self.changeNotificationStatus(email: "1", push: (appDelegate.loginUser?.pushNotify)! ? "1" : "0", sms: (appDelegate.loginUser?.smsNotify)! ? "1" : "0")
                    } else {
                        sender.isOn = false
                    }
                }
                
            } else {
                //...switch is in off
                
                self.showAlertConfirmationView(CDisableEmailNotificationMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                    if result {
                        sender.isOn = false
                        self.changeNotificationStatus(email: "0", push: (appDelegate.loginUser?.pushNotify)! ? "1" : "0", sms: (appDelegate.loginUser?.smsNotify)! ? "1" : "0")
                    } else {
                        sender.isOn = true
                    }
                }
            }
            
        case CSMSNotifications: //...SMS Notification Switch
            if sender.isOn {
                //...switch is in on
                self.showAlertConfirmationView(CEnableSMSNotificationMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                    if result {
                        sender.isOn = true
                        self.changeNotificationStatus(email: (appDelegate.loginUser?.emailNotify)! ? "1" : "0", push: (appDelegate.loginUser?.pushNotify)! ? "1" : "0", sms: "1")
                    } else {
                        sender.isOn = false
                    }
                }
                
            } else {
                //...switch is in off
                self.showAlertConfirmationView(CDisableSMSNotificationMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                    if result {
                        sender.isOn = false
                        self.changeNotificationStatus(email: (appDelegate.loginUser?.emailNotify)! ? "1" : "0", push: (appDelegate.loginUser?.pushNotify)! ? "1" : "0", sms: "0")
                    } else {
                        sender.isOn = true
                    }
                }
            }
            
        case CPaymentPassword: //...Payment Password Switch
            
            if sender.isOn {
                //...switch is in on
                sender.isOn = true
                self.changePaymentPasswordStatus(status: 1)
            } else {
                //...switch is in off
                sender.isOn = false
                self.changePaymentPasswordStatus(status: 0)
            }
            break
        default:
            break
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension SettingViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSetting.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_iPad ? CScreenWidth * (80 / 768) : CScreenWidth * (60 / 375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == arrSetting.count {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingVersionTblCell") as? SettingVersionTblCell {
                
                cell.lblVersion.text = "Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String)"
                //"Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String) (\(Bundle.main.infoDictionary?["CFBundleVersion"] as! String))" //
                return cell
            }
            
        } else {
           
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTblCell") as? SettingTblCell {
                
                cell.lblTitle.text = arrSetting[indexPath.row]
                
                switch arrSetting[indexPath.row] {
                case CPushNotifications:
                    cell.imgVArrow.isHidden = true
                    cell.switchNotify.isHidden = false
                    cell.switchNotify.isOn = (appDelegate.loginUser?.pushNotify)!
                    
                case CEmailNotifications:
                    cell.imgVArrow.isHidden = true
                    cell.switchNotify.isHidden = false
                    cell.switchNotify.isOn = (appDelegate.loginUser?.emailNotify)!
                    
                case CSMSNotifications:
                    cell.imgVArrow.isHidden = true
                    cell.switchNotify.isHidden = false
                    cell.switchNotify.isOn = (appDelegate.loginUser?.smsNotify)!
                    
                case CPaymentPassword:
                    cell.imgVArrow.isHidden = true
                    cell.switchNotify.isHidden = false
                    cell.switchNotify.isOn = (appDelegate.loginUser?.isCheckPassword)!
                    
                default :
                    if indexPath.row == arrSetting.count-1 {
                        cell.imgVArrow.isHidden = true
                        cell.switchNotify.isHidden = true
                    } else {
                        cell.imgVArrow.isHidden = false
                        cell.switchNotify.isHidden = true
                    }
                }
                
                
                cell.switchNotify.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
                
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch arrSetting[indexPath.row] {
        case CEditProfile:
            //...Edit Profile

            if  let editProfileVC = CStoryboardSetting.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController {
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
      
        case CChangePassword:
            //...Change Password
            if let changePwdVC = CStoryboardSetting.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
                self.navigationController?.pushViewController(changePwdVC, animated: true)
            }
     
        case CTermsConditions,CPrivacyPolicy,CAboutUs:
            //...Terms & Conditions, PrivacyPolicy and About Us
            
            if let cmsVC = CStoryboardSettingIphone.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
               
                if arrSetting[indexPath.row] == CTermsConditions {
                    cmsVC.cmsEnum = .TermsCondition
                } else if arrSetting[indexPath.row] == CPrivacyPolicy {
                    cmsVC.cmsEnum = .PrivacyPolicy
                } else {
                    cmsVC.cmsEnum = .AboutUs
                }
   
                self.navigationController?.pushViewController(cmsVC, animated: true)
            }
            
        case CAppSupport:
            //...Support

            if let supportVC = CStoryboardSetting.instantiateViewController(withIdentifier: "SupportViewController") as? SupportViewController {
                self.navigationController?.pushViewController(supportVC, animated: true)
            }
            
        case CRateApp:
            //...Rate App
            self.openInSafari(strUrl: AppLink)
            break
           
        case CLogout:
            //...Logout
            
            self.showAlertConfirmationView(CLogOutMessage, okTitle: CBtnYes, cancleTitle: CBtnNo, type: .confirmationView) { (result) in
                if result {
                 appDelegate.logout(isForDeleteUser: false)
                }
            }
  
        default:
           print("")
        }
    }
}

//MARK:-
//MARK:- API

extension SettingViewController {
    
    func changeNotificationStatus(email : String, push : String, sms : String) {
        
        //...For change push, email and SMS notificatin status
        APIRequest.shared().changeNotificationStatus(emailNotify: email, pushNotify: push, smsNotify:sms ) { (response, error) in
            
            if response != nil && error == nil {
                self.imgVBg.isHidden = false
            } else{
                self.imgVBg.isHidden = true
            }
        }
    }
    
    func changePaymentPasswordStatus(status : Int) {
       
        //...For change payment password status
        APIRequest.shared().checkPaymentPasswordStatus(status: status) { (response, error) in
            if response != nil {
                if let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject] {
                    appDelegate.loginUser?.isCheckPassword = responseData.valueForBool(key: "isCheckPassword")
                    CoreData.saveContext()
                }
            }
        }
    }
    
    func userDetail() {
        APIRequest.shared().userDetail { (response, error) in
            if response != nil && error == nil {
                self.imgVBg.isHidden = false
                self.initialize()
                self.tblSettings.reloadData()
            } else {
                self.imgVBg.isHidden = true
            }
        }
    }
}
