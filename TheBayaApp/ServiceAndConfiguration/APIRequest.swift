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

var BASEURL:String        =   "http://192.168.1.59/baya-app/api/v1/"

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


let CJsonResponse           = "response"
let CJsonMessage            = "message"
let CJsonStatus             = "status"
let CStatusCode             = "status_code"
let CJsonTitle              = "title"
let CJsonData               = "data"
let CJsonMeta               = "meta"

let CLimit                  = 7

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
let CStatus500              = 500
let CStatus550              = 550 // Inactive/Delete user
let CStatus555              = 555 // Invalid request
let CStatus556              = 556 // Invalid request
let CStatus1009             = -1009 // No Internet


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
                        
                        failure!(uRequest.task!, message, nil)
                    }
                    
                }
            }
        }
        
        return uRequest.task
    }
    
    func POST(param parameters:[String: AnyObject]?, multipartFormData: @escaping (MultipartFormData) -> Void, success:ClosureSuccess?,  failure:ClosureError?) -> Void
    {
        SessionManager.default.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
            for (key, value) in parameters! {
                multipart.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        },  to: (BASEURL!), method: HTTPMethod.post , headers: headers) { (encodingResult) in
            
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
                
            case CStatusTen :
                appDelegate.logout()
                
            default:
                if showAlert {
                    let message = meta.valueForString(key: CJsonMessage)
                    CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk) { (action) in
                    }
                }
            }
        }

        return false
    }
    
    
    func actionOnAPIFailure(errorMessage:String?, showAlert:Bool, strApiTag:String,error:NSError?) -> Void
    {
        MILoader.shared.hideLoader()
        if showAlert && errorMessage != nil {
            CTopMostViewController.presentAlertViewWithOneButton(alertTitle: "", alertMessage: errorMessage, btnOneTitle: CBtnOk) { (action) in
            }
        }
        
        print("API Error =" + "\(strApiTag )" + "\(String(describing: error?.localizedDescription))" )
    }
    
    func checkInternetConnection(complete:() -> Void) {
        
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
        noInternetVW?.frame = CGRect(x: 0, y: 64, width: CScreenWidth, height: CScreenHeight - 64)
        
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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCountry, error: error)
        })
        
    }
    
    func cms(completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.GET(apiTag: CAPITagCMS, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagCMS) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagCMS, error: error)
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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagSignUp, error: error)
        }
  
    }

    func loginUser (_ email: String?, _ password: String?, _ type:Int?, _ countryId : Int?, completion: @escaping ClosureCompletion)
    {
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagLogin, param: ["userName" : email as AnyObject, "password": password as AnyObject, "type": type as AnyObject, CCountryId : countryId as AnyObject], successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagLogin) {
                self.saveLoginUserDetail(response : response as! [String : AnyObject])
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagLogin, error: error)
        })
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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagVerifyUser, error: error)
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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagResendVerification, error: error)
        })
    }
    
    func forgotPassword(dict : [String : AnyObject],  completion: @escaping ClosureCompletion) {
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagForgotPassword, param: dict , successBlock: { (task, response) in
            
            MILoader.shared.hideLoader()
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagForgotPassword) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            MILoader.shared.hideLoader()
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagForgotPassword, error: error)
        })
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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagResetPassword, error: error)
        })
    }
    
    
    //TODO:
    //TODO: --------------PROFILE API--------------
    //TODO:
    

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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagEditProfile, error: error)
        })
    }
    
    func changeNotificationStatus(emailNotify: Int?, pushNotify: Int?, completion: @escaping ClosureCompletion) {
    
        _  = Networking.sharedInstance.POST(apiTag: CAPITagNotifyStatus, param: ["emailNotify" : emailNotify as AnyObject, "pushNotify": pushNotify as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagNotifyStatus) {
                self.saveLoginUserDetail(response : response as! [String : AnyObject])

                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagNotifyStatus, error: error)
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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagChangePassword, error: error)
        })
    }
    
    
    
    //TODO:
    //TODO: --------------PROJECT RELATED API--------------
    //TODO:
    
   
    func getProjectList (_ page : Int?, completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CAPITagProjectList, param: [CPage : page as AnyObject, CPerPage : CLimit as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagProjectList) {
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            
            completion(nil, error)
            if error?.code == CStatus1009 {
                self.checkInternetConnection {
                    _ = self.getProjectList(page, completion: completion)
                }
            } else {
                self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagProjectList, error: error)
            }
        })!
    }
    
    func subcribedProject (_ projectId : Int?, type: Int?, completion : @escaping ClosureCompletion) {
        
        _ = Networking.sharedInstance.POST(apiTag: CAPITagProjectSubscribe, param: [CProjectId : projectId as AnyObject, "type" : type as AnyObject], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagProjectSubscribe) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagProjectSubscribe, error: error)
        })
        
    }
    
    func getSubscribedProjectList(completion : @escaping ClosureCompletion) -> URLSessionTask {
        
        return Networking.sharedInstance.POST(apiTag: CAPITagSubscribedProject, param: [:], successBlock: { (task, response) in
            
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagProjectSubscribe) {
                completion(response, nil)
            }
        }, failureBlock: { (task, message, error) in
            completion(nil, error)
            if error?.code == CStatus1009 {
                self.checkInternetConnection {
                    _ = self.getSubscribedProjectList(completion: completion)
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
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagFavorite, error: error)
        })
    }
    
    //TODO:
    //TODO: --------------TIMELINE RELATED API--------------
    //TODO:
    
    func fetchTimelineList(_ projectId : Int?, startDate:String?, endDate:String?, page : Int?, completion : @escaping ClosureCompletion)  -> URLSessionTask {
        
        var para = [String : Any]()
        para[CProjectId] = projectId
        para[CPage] = page
        if startDate != nil{
            para[CIStartDate] = startDate
        }
        if endDate != nil{
            para[CIEndDate] = endDate
        }
        
        MILoader.shared.showLoader(type: .circularRing, message: "")
        return Networking.sharedInstance.POST(apiTag: CAPITagTimeline, param: para as [String : AnyObject], successBlock: { (task, response) in
            MILoader.shared.hideLoader()
            if self.checkResponseStatusAndShowAlert(showAlert: true, responseobject: response, strApiTag: CAPITagTimeline){
                completion(response, nil)
            }
            
        }, failureBlock: { (task, message, error) in
            MILoader.shared.hideLoader()
            self.actionOnAPIFailure(errorMessage: message, showAlert: true, strApiTag: CAPITagTimeline, error: error)
        })!
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

        let arrCountry = TblCountryList.fetch(predicate: NSPredicate(format:"%K == %d", CCountry_id, Int16(dict!.valueForInt(key: CCountryId)!)))
        
        tblUser.country_code = "+\(((arrCountry![0] as! TblCountryList).country_code) ?? "")"
        
        appDelegate.loginUser = tblUser
        
//        if (CUserDefaults.object(forKey: UserDefaultLoginUserToken) == nil) || (CUserDefaults.string(forKey: UserDefaultLoginUserToken)) == ""{

            if let token = metaData?.valueForString(key: "token") {
                CUserDefaults.setValue(token, forKey: UserDefaultLoginUserToken)
            }
        
            CUserDefaults.setValue(dict!.valueForInt(key: "userId"), forKey: UserDefaultLoginUserID)
            CUserDefaults.synchronize()
//        }

        
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




