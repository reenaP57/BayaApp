//
//  MIGeneralsAPI.swift
//  TheBayaApp
//
//  Created by Mac-00016 on 21/11/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MIGeneralsAPI: NSObject {

    var arrMaintenanceType = [[String : AnyObject]]()
    var arrProjectList = [[String : AnyObject]]()
    
    private override init() {
        super.init()
    }
    
    private static var generalAPI : MIGeneralsAPI = {
        let generalAPI = MIGeneralsAPI()
        return generalAPI
    }()
    
    static func shared() -> MIGeneralsAPI {
        return generalAPI
    }
}

//MARK:-
//MARK:- API Methods

extension MIGeneralsAPI {
    
    func fetchAllGeneralDataFromServer() {
        self.loadCountryList()
        if (CUserDefaults.value(forKey: UserDefaultLoginUserToken)) != nil {
            self.loadMaintenanceListFromServer()
            self.loadProjectListFromServer()
        }
    }
    
    func registerDeviceToken(fcmToken : String, isLoggedIn : Int?) {
        
        APIRequest.shared().registerDeviceToken(isLoggedIn: isLoggedIn, token: fcmToken) { (response, error) in
            
            if response != nil && error == nil {
                
                if isLoggedIn == 0 {
                    //...Log out
                    
                    appDelegate.tabbarViewcontroller = nil
                    appDelegate.tabbarView = nil
                    
                    appDelegate.loginUser = nil
                    CUserDefaults.removeObject(forKey: UserDefaultLoginUserToken)
                    CUserDefaults.removeObject(forKey: UserDefaultLoginUserID)
                    CUserDefaults.synchronize()
                    
                    appDelegate.initLoginViewController()
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
                    appDelegate.tabbarView?.lblCount.isHidden = true
                } else {
                    appDelegate.tabbarView?.lblCount.isHidden = false
                }
            }
        }
    }
    
    func loadMaintenanceListFromServer() {
        
        //...Load Maintenance Type
        APIRequest.shared().getMaintenanceList { (response, error) in
            
            if response != nil {
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    if arrData.count > 0 {
                        self.arrMaintenanceType = arrData
                    }
                }
            }
        }
    }
    
    
    func loadProjectListFromServer() {
        
        //...Load project list from server for show list on project field
        _ = APIRequest.shared().getProjectList(1, false, completion: { (response, error) in
            
            if response != nil && error == nil {
                let arrData = response?.value(forKey: CJsonData) as! [[String : AnyObject]]
                
                if arrData.count > 0 {
                    for item in arrData {
                        if item.valueForInt(key: CIsVisit) == 1 {
                            self.arrProjectList.append(item)
                        }
                    }
                }
            }
        })
    }
}
