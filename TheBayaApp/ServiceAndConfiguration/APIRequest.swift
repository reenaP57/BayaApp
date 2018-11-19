//
//  APIRequest.swift
//  Social Media
//
//  Created by mac-0005 on 06/06/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage


//MARK:- ---------BASEURL __ TAG

var BASEURL:String          =   "http://itrainacademy.in/baya-app/api/v2/" //Local
//var BASEURL:String          =   "https://api.thebayacompany.com/v1" //Live

let CAPITagCountry             =   "country"
let CAPITagSignUp              =   "signup"
let CAPITagLogin               =   "login"
let CAPITagVerifyUser          =   "verifyuser"
let CAPITagResendVerification  =   "resend-verification"
let CAPITagForgotPassword      =   "forgot-password"
let CAPITagResetPassword       =   "reset-password"
let CAPITagEditProfile         =   "editprofile"
let CAPITagNotifyStatus        =   "notifystatus"
let CAPITagChangePassword      =   "changepassword"
let CAPITagCMS                 =   "cms"
let CAPITagProjectList         =   "projectlist"
let CAPITagProjectSubscribe    =   "project-subscribe"
let CAPITagSubscribedProject   =   "subscribed-project"
let CAPITagProjectDetails      =   "project-details"
let CAPITagFavorite            =   "favorite"
let CAPITagTimeline            =   "timelinelist"
let CAPITagScheduleVisit       =   "schedule-visit"
let CAPITagVisitList           =   "visitlist"
let CAPITagRateVisit           =   "rate-visit"
let CAPITagSupport             =   "support"
let CAPITagBrochure            =   "brochure"
let CAPITagAmenities           =   "amenities"
let CAPITagLocationAdvantages  =   "location-advantages"
let CAPITagDeviceToken         =   "device-token"
let CAPITagNotificationList    =   "notificationlist"
let CAPITagBadgeCount          =   "badge-count"
let CAPITagPushNotifyCount     =   "push-notify-count"
let CAPITagPostViewCount       =   "post-view-count"
let CAPITagUserprofile         =   "userprofile"

let CAPITagDocuments             =   "documents"
let CAPITagDocumentRequest       =   "document-request"
let CAPITagPostDocumentRequest   =   "post-document-request"
let CAPITagViewDocumentRequest   =   "view-document-request"
let CAPITagPostMaintenance       =   "post-maintenance"
let CAPITagMaintenance             =   "maintenance"
let CAPITagViewMaintenanceRequest  =   "view-maintenance-request"
let CAPITagRateMaintenanceRequest  =   "rate-maintenance-request"


let CJsonResponse           = "response"
let CJsonMessage            = "message"
let CJsonStatus             = "status"
let CStatusCode             = "status_code"
let CJsonTitle              = "title"
let CJsonData               = "data"
let CJsonMeta               = "meta"

let CLimit                  = 20

let CStatusZero             = 0
let CStatusOne              = 1
let CStatusTwo              = 2
let CStatusThree            = 3
let CStatusFour             = 4
let CStatusFive             = 5
let CStatusEight            = 8
let CStatusNine             = 9
let CStatusTen              = 10
let CStatusEleven           = 11

let CStatus200              = 200 // Success
let CStatus400              = 400 
let CStatus401              = 401 // Unauthorized
let CStatus405              = 405 // User Deleted
let CStatus500              = 500
let CStatus550              = 550 // Inactive/Delete user
let CStatus555              = 555 // Invalid request
let CStatus556              = 556 // Invalid request
let CStatus1009             = -1009 // No Internet
let CStatus1005             = -1005 //Network connection lost

//MARK:- ---------Networking
typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?) -> Void
typealias ClosureError   = (_ task:URLSessionTask, _ message:String?, _ error:NSError?) -> Void

class Networking: NSObject
{
    var BASEURL:String?
    
    var headers:[String: String] {
        
        if UserDefaults.standard.value(forKey: UserDefaultLoginUserToken) != nil {
            return ["Authorization" : "Bearer \((CUserDefaults.value(forKey: UserDefaultLoginUserToken)) as? String ?? "")","Accept-Language" : "en","Accept" : "application/json"]
        } else {
            return ["Accept" : "application/json","Accept-Language" : "en"]
        }
    }

    
    var loggingEnabled = true
    var activityCount = 0
    
    
    /// Networking Singleton
    static let sharedInstance = Networking.init()
    override init() {
        super.init()
    }
    
    fileprivate func logging(request req:Request?) -> Void
    {
        if (loggingEnabled && req != nil)
        {
            var body:String = ""
            var length = 0
            
            if (req?.request?.httpBody != nil) {
                body = String.init(data: (req!.request!.httpBody)!, encoding: String.Encoding.utf8)!
                length = req!.request!.httpBody!.count
            }
            
            let printableString = "\(req!.request!.httpMethod!) '\(req!.request!.url!.absoluteString)': \(String(describing: req!.request!.allHTTPHeaderFields)) \(body) [\(length) bytes]"
            
            print("API Request: \(printableString)")
        }
    }
    
    fileprivate func logging(response res:DataResponse<Any>?) -> Void
    {
        if (loggingEnabled && (res != nil))
        {
            if (res?.result.error != nil) {
                print("API Response: (\(String(describing: res?.response?.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Error:\(String(describing: res?.result.error))")
            } else {
                
                let data = res?.result.value as? [String : AnyObject]
                if res?.response!.statusCode == CStatus400
                {
                    CTopMostViewController.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: (data?.valueForString(key: CJsonMessage)), btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    }, btnTwoTitle:CBtnCancel) { (action) in
                    }
                    
                }else if res?.response!.statusCode == CStatus401 || res?.response!.statusCode == CStatus405
                {
                    CTopMostViewController.showAlertView((data?.valueForString(key: CJsonMessage))) { (result) in
                        if result {
                            appDelegate.logout(isForDeleteUser: true)
                        }
                    }
                    
//                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: (data?.valueForString(key: CJsonMessage)), btnOneTitle: CBtnOk) { (action) in
//                        appDelegate.logout(isForDeleteUser: true)
//                    }
                }
                
                print("API Response: (\(String(describing: res?.response!.statusCode))) [\(String(describing: res?.timeline.totalDuration))s] Response:\(String(describing: res?.result.value))")
            }
        }
    }
    
    
    
    /// Uploading
    
    func upload(
        _ URLRequest: URLRequestConvertible,
        multipartFormData: (MultipartFormData) -> Void,
        encodingCompletion: ((SessionManager.MultipartFormDataEncodingResult) -> Void)?) -> Void
    {
        
        let formData = MultipartFormData()
        multipartFormData(formData)
        
        
        var URLRequestWithContentType = try? URLRequest.asURLRequest()
        
        URLRequestWithContentType?.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
        
        let fileManager = FileManager.default
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileName = UUID().uuidString
        
        #if swift(>=2.3)
            let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
            let fileURL = directoryURL.appendingPathComponent(fileName)
        #else
            
            let directoryURL = tempDirectoryURL.appendingPathComponent("com.alamofire.manager/multipart.form.data")
            let fileURL = directoryURL.appendingPathComponent(fileName)
        #endif
        
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            try formData.writeEncodedData(to: fileURL)
            
            DispatchQueue.main.async {
                
                let encodingResult = SessionManager.MultipartFormDataEncodingResult.success(request: SessionManager.default.upload(fileURL, with: URLRequestWithContentType!), streamingFromDisk: true, streamFileURL: fileURL)
                encodingCompletion?(encodingResult)
            }
        } catch {
            DispatchQueue.main.async {
                encodingCompletion?(.failure(error as NSError))
            }
        }
    }
    
    // HTTPs Methods
    func GET(param parameters:[String: AnyObject]?, success:ClosureSuccess?,  failure:ClosureError?) -> URLSessionTask?
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && response.response?.statusCode == 200)
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil , response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task
    }
    
    func GET(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask?
    {
        
        let uRequest = SessionManager.default.request((BASEURL! + tag), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && response.response?.statusCode == 200)
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!,nil, response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task
    }
    
    func POST(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask?
    {
        let uRequest = SessionManager.default.request((BASEURL! + tag), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200, 201, 401] .contains(response.response!.statusCode)) )
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
                
            }
//            else if ([405, 403] .contains(response.response!.statusCode)) {
//
//                appDelegate.logout(isForDeleteUser: false)
//
//            }
            else {
                if(failure != nil) {
                    
                    if response.result.error != nil
                    {
                        failure!(uRequest.task!,nil, response.result.error as NSError?)
                    }
                    else
                    {
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: "message") else
                        {
                            return failure!(uRequest.task!,nil, nil)
                        }
                        
                        failure!(uRequest.task!, message, nil)
                    }
                    
                }
            }
        }
        
        return uRequest.task
    }
    
    func POST(param parameters:[String: AnyObject]?, tag:String?, multipartFormData: @escaping (MultipartFormData) -> Void, success:ClosureSuccess?,  failure:ClosureError?) -> Void
    {
        SessionManager.default.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
            if parameters != nil
            {
                for (key, value) in parameters!
                {
                    multipart.append("\(value)".data(using: .utf8)!, withName: key)
                    //  multipart.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
                }
            }
            
        },  to: (BASEURL! + (tag ?? "")), method: HTTPMethod.post , headers: headers) { (encodingResult) in
            
            
            switch encodingResult {
                
            case .success(let uRequest, _, _):
                
                self.logging(request: uRequest)
                
                uRequest.responseJSON { (response) in
                    
                    self.logging(response: response)
                    if(response.result.error == nil)
                    {
                        if(success != nil) {
                            success!(uRequest.task!, response.result.value as AnyObject)
                        }
                    }
                    else
                    {
                        if(failure != nil) {
                            failure!(uRequest.task!,nil, response.result.error as NSError?)
                        }
                    }
                }
                
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
        
    }
    
    func HEAD(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .head, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!,nil, response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task!
    }
    
    func PATCH(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil, response.result.error as NSError?)
                }
            }
        }
        
        return uRequest.task!
    }
    
    func PUT(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?,   failureBlock failure:ClosureError?) -> URLSessionTask?
    {
        
        let uRequest = SessionManager.default.request(BASEURL!+tag, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if(response.result.error == nil && ([200,201] .contains(response.response!.statusCode)) )
            {
                if(success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    
                    if response.result.error != nil
                    {
                        failure!(uRequest.task!,nil, response.result.error as NSError?)
                    }
                    else
                    {
                        let dict = response.result.value as? [String : AnyObject]
                        
                        guard let message = dict?.valueForString(key: "message") else
                        {
                            return failure!(uRequest.task!,nil, nil)
                        }
                        
                        failure!(uRequest.task!,message, nil)
                    }
                    
                }
            }
        }
        
        
        return uRequest.task!
    }
    
    func PUT(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil, response.result.error as NSError?)
                }
            }
            
        }
        
        return uRequest.task!
    }
    
    func DELETE(param parameters: [String: AnyObject]?, success : ClosureSuccess?, failure:ClosureError?) -> URLSessionTask
    {
        
        let uRequest = SessionManager.default.request(BASEURL!, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        self.logging(request: uRequest)
        
        uRequest.responseJSON { (response) in
            
            self.logging(response: response)
            if response.result.error == nil
            {
                if (success != nil) {
                    success!(uRequest.task!, response.result.value as AnyObject)
                }
            }
            else
            {
                if(failure != nil) {
                    failure!(uRequest.task!, nil, response.result.error as NSError?)
                    
                }
            }
        }
        
        return uRequest.task!
    }
}



//MARK:- ---------General
class APIRequest: NSObject {
    
    typealias ClosureCompletion = (_ response:AnyObject?, _ error:NSError?) -> Void
    typealias successCallBack = (([String:AnyObject]?) -> ())
    typealias failureCallBack = ((String) -> ())
    
    private var isInvalidUserAlertDisplaying = false
    
    private override init() {
        super.init()
    }
    
    private static var apiRequest:APIRequest {
        let apiRequest = APIRequest()
        
        if (BASEURL.count > 0 && !BASEURL.hasSuffix("/")) {
            BASEURL = BASEURL + "/"
        }
        
        Networking.sharedInstance.BASEURL = BASEURL
        return apiRequest
    }
    
    static func shared() -> APIRequest {
        return apiRequest
    }
    
    func isJSONDataValid(withResponse response: AnyObject!) -> Bool
    {
        if (response == nil) {
            return false
        }
        
        let data = response.value(forKey: CJsonData)
        
        if !(data != nil) {
            return false
        }
        
        if (data is String) {
            if ((data as? String)?.count ?? 0) == 0 {
                return false
            }
        }
        
        if (data is [Any]) {
            if (data as? [Any])?.count == 0 {
                return false
            }
        }
        
        return self.isJSONStatusValid(withResponse: response)
    }
    
    func isJSONStatusValid(withResponse response: AnyObject!) -> Bool {
        
        if response == nil {
            return false
        }
        
        let responseObject = response as? [String : AnyObject]
        
        if let meta = responseObject?[CJsonMeta]  as? [String : AnyObject] {
            
            if meta.valueForString(key: CStatusCode).toInt == CStatus200  {
                return  true
            } else {
                return false
            }
        }
        
        
        if  responseObject?.valueForString(key: CStatusCode).toInt == CStatus200 {
            return  true
        } else {
            return false
        }
    }
    
    
    func checkResponseStatusAndShowAlert(showAlert:Bool, responseobject: AnyObject?, strApiTag:String) -> Bool
    {
        MILoader.shared.hideLoader()
        
        if let meta = responseobject?.value(forKey: CJsonMeta) as? [String : Any] {
            
            switch meta.valueForInt(key: CJsonStatus) {
            case CStatusZero:
                return true
                
            case CStatusFour:
                return true
                
            case CStatusTen : //register from admin
                return true
                
            default:
                if showAlert {
                    let message = meta.valueForString(key: CJsonMessage)
                    CTopMostViewController.showAlertView(message) { (result) in
                        if result {
                            if appDelegate.topViewController() is ProjectDetailViewController {
                                appDelegate.topViewController()?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    
//                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk) { (action) in
//
//                        if appDelegate.topViewController() is ProjectDetailViewController {
//                            appDelegate.topViewController()?.navigationController?.popViewController(animated: true)
//                        }
//                    }
                }
            }
        }

        return false
    }
    
    
    func actionOnAPIFailure(errorMessage:String?, showAlert:Bool, strApiTag:String,error:NSError?) -> Void
    {
        MILoader.shared.hideLoader()
        if showAlert && errorMessage != nil {
            CTopMostViewController.showAlertView(errorMessage) { (result) in
            }
//            CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMessage, btnOneTitle: CBtnOk) { (action) in
//            }
        }
        
        print("API Error =" + "\(strApiTag )" + "\(String(describing: error?.localizedDescription))" )
    }
    
    func checkInternetConnection(complete:@escaping () -> Void) {
        
        var isScreenFind = false
        
        for objView in CTopMostViewController.view.subviews {
            if objView .isKind(of: NoInternetView.classForCoder()) {
                isScreenFind = true
                break
            }
        }
        
        if isScreenFind {
            return
        }

        
        let noInternetVW = NoInternetView.viewFromNib(is_ipad: false) as? NoInternetView
        noInternetVW?.frame = CGRect(x: 0, y: 0, width: CScreenWidth, height: CScreenHeight) //CGRect(x: 0, y: 64, width: CScreenWidth, height: CScreenHeight - 64)
        
        let net = NetworkReachabilityManager()
        net?.startListening()
        
        CTopMostViewController.view.addSubview(noInternetVW!)
        
        noInternetVW?.btnTryAgain.touchUpInside(genericTouchUpInsideHandler: { (sender) in
            
            if (net?.isReachable)! {
                //...Network Available
                print("Network Available")
                noInternetVW?.removeFromSuperview()
                complete()
            }
        })
    }
}



//MARK:- ---------API Functions

extension APIRequest {
    
    
    //TODO:
    //TODO: --------------GENERAL API--------------
    //TODO:
    
    func getCountryList(_timestamp : AnyObject, completion: @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagCountry, param: [CTimestamp :_timestamp], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: false, responseobject: response, strApiTag: CAPITagCountry) {
                
                self.saveCountryList(response: response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getCountryList(_timestamp: _timestamp, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCountry, error: error)
            }
            
        })
        
    }
    
    func cms(completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagCMS, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCMS) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.cms(completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCMS, error: error)
            }
            
        })
    }
    
    func registerDeviceToken(isLoggedIn : Int?, token : String?, completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagDeviceToken, param: ["deviceType" : 2 as AnyObject, "deviceToken" : token as AnyObject, "isLoggedIn" : isLoggedIn as AnyObject], successBlock: { (task, response) in
        
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagDeviceToken) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
        
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.registerDeviceToken(isLoggedIn: isLoggedIn, token: token, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDeviceToken, error: error)
            }
        })
        
    }
    
    
    func notificationList(page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader{
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        return Networking.sharedInstance.POST(apiTag: CAPITagNotificationList, param: [CPage : page as AnyObject, CPerPage : CLimit as AnyObject], successBlock: { (task, response) in
            
            if showLoader{
                MILoader.shared.hideLoader()
            }
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotificationList){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            if showLoader{
                MILoader.shared.hideLoader()
            }
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.notificationList(page: page,showLoader : showLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagNotificationList, error: error)
            }
        })!
    }
    
    func unreadCount(completion : @escaping ClosureCompletion) {
    
        _ = Networking.sharedInstance.POST(apiTag: CAPITagBadgeCount, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagBadgeCount){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
          
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagBadgeCount, error: error)
        })
    }
    
    func pushNotifiyCount(adminNotifyId : Int?, completion : @escaping ClosureCompletion){
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagPushNotifyCount, param: ["adminNotifyId" : adminNotifyId as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagPushNotifyCount) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagPushNotifyCount, error: error)
        })
    }
    
    
    //TODO:
    //TODO: --------------LRF API--------------
    //TODO:
    
    func signUpUser (_dict: [String : AnyObject], completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagSignUp, param: _dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagSignUp){
                
                self.saveLoginUserDetail(response : response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }) { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.signUpUser(_dict: _dict, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSignUp, error: error)
            }
        }
  
    }

    func loginUser (_ email: String?, _ password: String?, _ type:Int?, _ countryId : Int?, completion: @escaping ClosureCompletion)
    {
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        let dict = ["userName" : email as AnyObject,
                    "password": password as AnyObject,
                    "type": type as AnyObject,
                    CCountryId : countryId as AnyObject,
                    "deviceInfo" : ["platform" : "IOS",
                                    "deviceVersion" :appDelegate.deviceName,
                                    "deviceOS" : UIDevice.current.systemVersion,
                                    "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String]] as [String : Any]
        
        
        Networking.sharedInstance.POST(param: dict as [String : AnyObject], tag: CAPITagLogin, multipartFormData: { (data) in
            
        }, success: { (task, response) in
            
            MILoader.shared.hideLoader()
            
          let metaData = response?.value(forKey: CJsonMeta) as? [String : Any]
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagLogin) {
            
                self.saveLoginUserDetail(response : response as! [String : AnyObject])
             
                if metaData?.valueForInt(key: "status") == CStatusZero {
                    
                    if let fcmToken = CUserDefaults.value(forKey: UserDefaultFCMToken) as? String{
                        appDelegate.registerDeviceToken(fcmToken: fcmToken, isLoggedIn: 1)
                    }
                    
                }
                
                completion(response, nil)
            }
            
        }) { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.loginUser(email, password, type, countryId, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagLogin, error: error)
            }
        }

    }
    
    func verifyUser(_ dict : [String : AnyObject], completion: @escaping ClosureCompletion) {
       
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagVerifyUser, param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagVerifyUser){
                
                self.saveLoginUserDetail(response : response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.verifyUser(dict, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagVerifyUser, error: error)
            }
            
        })
    }
    
    func resendVerificationCode(_ dict : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagResendVerification, param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagResendVerification) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    self.resendVerificationCode(dict, completion: completion)
                }
                
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagResendVerification, error: error)
            }
        })
    }
    
    func forgotPassword(dict : [String : AnyObject],  completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        Networking.sharedInstance.POST(param: dict, tag: CAPITagForgotPassword, multipartFormData: { (data) in
            
        }, success: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagForgotPassword) {
                completion(response, nil)
            }
            
        }) { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.forgotPassword(dict: dict, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagForgotPassword, error: error)
            }
        }

    }
    
    func resetPassword(_ dict : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagResetPassword, param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagResetPassword) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.resetPassword(dict, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagResetPassword, error: error)
            }
            
        })
    }
    
    
    //TODO:
    //TODO: --------------PROFILE API--------------
    //TODO:
    
    func userDetail(completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagUserprofile, param: [:], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagUserprofile) {
                self.saveLoginUserDetail(response : response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.userDetail(completion: completion)
                }
                
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagUserprofile, error: error)
            }
        })
        
    }
    
    
    func editProfile(_ firstName : String?, _ lastName : String?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagEditProfile, param: [CFirstName : firstName as AnyObject, CLastName : lastName as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagEditProfile) {
                self.saveLoginUserDetail(response : response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.editProfile(firstName, lastName, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagEditProfile, error: error)
            }
        })
    }
    
    func changeNotificationStatus(emailNotify: String?, pushNotify: String?, smsNotify: String?, completion: @escaping ClosureCompletion) {
    
        _  = Networking.sharedInstance.POST(apiTag: CAPITagNotifyStatus, param: ["emailNotify" : emailNotify as AnyObject, "pushNotify": pushNotify as AnyObject, "mobileNotify": smsNotify as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotifyStatus) {
                self.saveLoginUserDetail(response : response as! [String : AnyObject])

                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.changeNotificationStatus(emailNotify: emailNotify, pushNotify: pushNotify, smsNotify: smsNotify, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagNotifyStatus, error: error)
            }
            
        })
        
    }
    
    func changePassword (_ oldPwd : String?, _ newPwd : String?, completion : @escaping ClosureCompletion){
    
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagChangePassword, param: ["oldPassword" : oldPwd as AnyObject, "password" : newPwd as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagChangePassword){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.changePassword(oldPwd, newPwd, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagChangePassword, error: error)
            }
            
        })
    }
    
    
    
    //TODO:
    //TODO: --------------PROJECT RELATED API--------------
    //TODO:
    
   
    func getProjectList (_ page : Int?, _ showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader {
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        return Networking.sharedInstance.POST(apiTag: CAPITagProjectList, param: [CPage : page as AnyObject, CPerPage : CLimit as AnyObject], successBlock: { (task, response) in
            
            if showLoader {
                MILoader.shared.hideLoader()
            }
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagProjectList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            if showLoader {
                MILoader.shared.hideLoader()
            }
            
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005  {
                self.checkInternetConnection {
                    _ = self.getProjectList(page, showLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagProjectList, error: error)
            }
        })!
    }
    
    func getProjectDetail(projectId : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) {
        
        if showLoader {
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagProjectDetails, param: [CProjectId : projectId as AnyObject], successBlock: { (task, response) in
            
            if showLoader {
                MILoader.shared.hideLoader()
            }
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagProjectDetails) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            if showLoader {
                MILoader.shared.hideLoader()
            }
            completion(nil, error)
            if error?.code == CStatus1009  || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getProjectDetail(projectId: projectId,showLoader : true, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagProjectDetails, error: error)
            }
        })
    }
    
    func subcribedProject (_ projectId : Int?, type: Int?, completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagProjectSubscribe, param: [CProjectId : projectId as AnyObject, "type" : type as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagProjectSubscribe) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.subcribedProject(projectId, type: type, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagProjectSubscribe, error: error)
            }
            
        })
        
    }
    
    func getSubscribedProjectList(showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader{
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        return Networking.sharedInstance.POST(apiTag: CAPITagSubscribedProject, param: [:], successBlock: { (task, response) in
            
            if showLoader{
                MILoader.shared.hideLoader()
            }
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagProjectSubscribe) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            if showLoader{
                MILoader.shared.hideLoader()
            }
            completion(nil, error)
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getSubscribedProjectList(showLoader: showLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagProjectSubscribe, error: error)
            }
        })!
    }
    
    func favouriteSubcribedProject(_ projectId : Int?, type : Int?, completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagFavorite, param: [CProjectId : projectId as AnyObject, "type" : type as AnyObject], successBlock: { (task, response) in
           
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagFavorite){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
        
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.favouriteSubcribedProject(projectId, type: type, completion: completion)
                }
                
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagFavorite, error: error)
            }
            
        })
    }
    
    
    func projectBrochure (projectId : Int?,completion : @escaping ClosureCompletion){
        
        let dict = [CProjectId : projectId!,
                    "deviceInfo" : ["platform" : "IOS",
                                    "deviceVersion" :appDelegate.deviceName,
                                    "deviceOS" : UIDevice.current.systemVersion,
                                    "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String]] as [String : Any]
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        Networking.sharedInstance.POST(param: dict as [String : AnyObject], tag: CAPITagBrochure, multipartFormData: { (data) in
            
        }, success: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagBrochure){
                completion(response, nil)
            }
            
        }) { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.projectBrochure(projectId: projectId, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagBrochure, error: error)
            }
            
        }
    }
    
    
    func getAmenities (projectId : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) {
        
        if showLoader{
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagAmenities, param: [CProjectId : projectId as AnyObject], successBlock: { (task, response) in
            
            if showLoader{
                MILoader.shared.showLoader(type: .circularRing, message: "")
            }
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagAmenities) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            if showLoader{
                MILoader.shared.showLoader(type: .circularRing, message: "")
            }
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getAmenities(projectId: projectId, showLoader: showLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagAmenities, error: error)
            }
        })
    }
    
    
    func getLocationAdvantages (projectId : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) {
        
        if showLoader{
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagLocationAdvantages, param: [CProjectId : projectId as AnyObject], successBlock: { (task, response) in
            
            if showLoader{
                MILoader.shared.showLoader(type: .circularRing, message: "")
            }
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagLocationAdvantages) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            if showLoader{
                MILoader.shared.showLoader(type: .circularRing, message: "")
            }
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getLocationAdvantages(projectId: projectId, showLoader : showLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagLocationAdvantages, error: error)
            }
        })
    }
    
    
    
    
    //TODO:
    //TODO: --------------VISIT RELATED API--------------
    //TODO:
    
    
    
    func scheduleVisit(dict : [String : AnyObject], completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagScheduleVisit, param: dict, successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagScheduleVisit){
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.scheduleVisit(dict: dict, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagScheduleVisit, error: error)
            }
        })
        
    }
    
    func getVisitList(page : Int?, showLoader : Bool, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        if showLoader{
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        return Networking.sharedInstance.POST(apiTag: CAPITagVisitList, param: [CPage : page as AnyObject, CPerPage : CLimit as AnyObject], successBlock: { (task, response) in
            
            if showLoader{
                MILoader.shared.hideLoader()
            }
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagVisitList){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
           
            if showLoader{
                MILoader.shared.hideLoader()
            }
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getVisitList(page: page, showLoader : showLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagVisitList, error: error)
            }
        })!
    }
    
    func rateVisit (visitId : Int?, rating : Int?, desc : String?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagRateVisit, param: ["visitId" : visitId as AnyObject, "ratings" : rating as AnyObject, "description" : desc as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagRateVisit) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.rateVisit(visitId: visitId, rating: rating, desc: desc, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagRateVisit, error: error)
            }
        })
    }
    
    func support (dict : [String : AnyObject], imgData : Data?, completion : @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(param: dict as [String : AnyObject], tag: CAPITagSupport, multipartFormData: { (formData) in

            if imgData?.count != 0 {
                formData.append(imgData!, withName: CImage, fileName:  String(format: "%.0f.jpg", Date().timeIntervalSince1970 * 1000), mimeType: "image/jpeg")
            }

        }, success: { (task, response) in

            MILoader.shared.hideLoader()

            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagSupport){
                completion(response, nil)
            }

        }, failure: { (task, message, error) in

            MILoader.shared.hideLoader()
            completion(nil, error)

            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.support(dict: dict, imgData: imgData, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSupport, error: error)
            }

        })
    }
    
    
    
    //TODO:
    //TODO: --------------TIMELINE RELATED API--------------
    //TODO:
    
    func postVisitCount(postId : String,completion :@escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagPostViewCount, param: ["postId" : postId as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagPostViewCount){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.postVisitCount(postId: postId, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagPostViewCount, error: error)
            }
        })
    }
    
    
    func fetchTimelineList(_ projectId : Int?, startDate:String?, endDate:String?, page : Int?, shouldShowLoader : Bool?, completion : @escaping ClosureCompletion)  -> URLSessionTask {
        
        var para = [String : Any]()
        para[CProjectId] = projectId
        para[CPage] = page
        if startDate != nil{
            para[CIStartDate] = startDate
        }
        if endDate != nil{
            para[CIEndDate] = endDate
        }
        
        if shouldShowLoader!{
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        return Networking.sharedInstance.POST(apiTag: CAPITagTimeline, param: para as [String : AnyObject], successBlock: { (task, response) in
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagTimeline){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.fetchTimelineList(projectId, startDate: startDate, endDate: endDate, page: page, shouldShowLoader : shouldShowLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagTimeline, error: error)
            }
        })!
    }
    
    
    //TODO:
    //TODO: --------------DOCUMENT RELATED API--------------
    //TODO:
    
    func getDocumentList(type : Int, page : Int?, shouldShowLoader : Bool?, completion : @escaping ClosureCompletion) -> URLSessionTask {
    
        if shouldShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        return Networking.sharedInstance.POST(apiTag: CAPITagDocuments, param: [CPerPage : CLimit as AnyObject, CPage : page as AnyObject, "type" : type as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagDocuments){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getDocumentList(type: type, page: page, shouldShowLoader: shouldShowLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDocuments, error: error)
            }
     
        })!
        
    }
    
    func postDocumentRequest(docName : String, msg : String, completion :@escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
 
       _ = Networking.sharedInstance.POST(apiTag: CAPITagPostDocumentRequest, param: ["documentName" : docName as AnyObject, "message" : msg as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagPostDocumentRequest) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.postDocumentRequest(docName: docName, msg: msg, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagPostDocumentRequest, error: error)
            }
        })
    }
    
    func getDocumentRequest(page : Int, shouldShowLoader : Bool?, completion : @escaping ClosureCompletion) -> URLSessionTask {
    
        if shouldShowLoader! {
            MILoader.shared.showLoader(type: .circularRing, message: "")
        }
        
        return Networking.sharedInstance.POST(apiTag: CAPITagDocumentRequest, param: [CPerPage : CLimit as AnyObject, CPage : page as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagDocumentRequest) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.getDocumentRequest(page: page, shouldShowLoader: shouldShowLoader, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagDocumentRequest, error: error)
            }
        })!
    }
    
    
    func viewDocumentRequest(docID : Int?, completion : @escaping ClosureCompletion) {
    
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagViewDocumentRequest, param: ["id" : docID as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagViewDocumentRequest){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            completion(nil, error)
            
            if error?.code == CStatus1009 || error?.code == CStatus1005 {
                self.checkInternetConnection {
                    _ = self.viewDocumentRequest(docID: docID, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagViewDocumentRequest, error: error)
            }
        })
    }
    
    
    //TODO:
    //TODO: -------------- Store in local --------------
    //TODO:
    
    
    func saveLoginUserDetail(response : [String : AnyObject]) {
        
        let dict = response.valueForJSON(key: CJsonData) as? [String : AnyObject]
        let metaData = response.valueForJSON(key: CJsonMeta) as? [String : AnyObject]

        let tblUser = TblUser.findOrCreate(dictionary: ["user_id": Int64(dict!.valueForInt(key: "userId")!)]) as! TblUser

        tblUser.firstName = dict!.valueForString(key: CFirstName)
        tblUser.lastName = dict!.valueForString(key: CLastName)
        tblUser.email = dict!.valueForString(key: CEmail)
        tblUser.mobileNo = dict!.valueForString(key: CMobileNo)
        tblUser.pushNotify = dict!.valueForBool(key: CPushNotify)
        tblUser.countryId = Int16(dict!.valueForInt(key: CCountryId)!)
        tblUser.emailNotify = dict!.valueForBool(key: CEmailNotify)
        tblUser.emailVerify = dict!.valueForBool(key: CEmailVerify)
        tblUser.mobileVerify = dict!.valueForBool(key: CMobileVerify)
        tblUser.pushNotify = dict!.valueForBool(key: CPushNotify)
        tblUser.userType = Int16(dict!.valueForInt(key: CUserType)!)
        tblUser.postBadge = Int16(dict!.valueForInt(key: CFavoriteProjectBadge)!)
        tblUser.projectBadge = Int16(dict!.valueForInt(key: "projectCount")!)
        tblUser.projectProgress = Int16(dict!.valueForInt(key: CFavoriteProjectProgress)!)
        tblUser.project_name = dict!.valueForString(key: CFavoriteProjectName)
        tblUser.smsNotify = dict!.valueForBool(key: CMobileNotify)
        tblUser.fav_project_id = Int64(dict!.valueForInt(key: "favoriteProjectId")!)
        
        let arrCountry = TblCountryList.fetch(predicate: NSPredicate(format:"%K == %d", CCountry_id, Int16(dict!.valueForInt(key: CCountryId)!)))
        
        tblUser.country_code = ((arrCountry![0] as! TblCountryList).country_code)
        
        appDelegate.loginUser = tblUser
        
        if metaData?.valueForString(key: "token") != "" {
           
            if let token = metaData?.valueForString(key: "token") {
                CUserDefaults.setValue(token, forKey: UserDefaultLoginUserToken)
                CUserDefaults.synchronize()
            }
        }


        CUserDefaults.setValue(dict!.valueForInt(key: "userId"), forKey: UserDefaultLoginUserID)
        CoreData.saveContext()
    }
    
    func saveCountryList(response : [String : AnyObject]) {
        
        let data = response.valueForJSON(key: CJsonData) as? [[String : AnyObject]]
        
        for item in data! {
            
            let tblCountry = TblCountryList.findOrCreate(dictionary: ["country_id":Int16(item.valueForInt(key: CId)!)]) as! TblCountryList
            
            tblCountry.country_code = item.valueForString(key: CCountry_code)
            tblCountry.country_name = item.valueForString(key: CCountry_name)
            tblCountry.status_id = Int16(item.valueForInt(key: CStatus_id)!)
            tblCountry.country_with_code = "\(item.valueForString(key: CCountry_name)) - \(item.valueForString(key: CCountry_code))"
        }
        
        CoreData.saveContext()
    }
    
}




