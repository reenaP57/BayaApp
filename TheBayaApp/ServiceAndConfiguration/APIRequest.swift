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
//var BASEURL:String        =   "http://180.211.104.102/PangeaPod/api/v1/"    //...Local
var BASEURL:String        =   "https://d1.pangeapod.com/PangeaPod/api/v1/"    //...Live


let CAPITagCheckUser                        = "CheckUser"




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
let CStatus500              = 500
let CStatus550              = 550 // Inactive/Delete user
let CStatus555              = 555 // Invalid request
let CStatus556              = 556 // Invalid request


//MARK:- ---------Networking
typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?) -> Void
typealias ClosureError   = (_ task:URLSessionTask, _ message:String?, _ error:NSError?) -> Void

class Networking: NSObject
{
    var BASEURL:String?
    
    var headers:[String: String]
    {
        var headersData = ["Authorization":"", "Accept":"application/json", "Accept-Language":"en"]
        return headersData
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
    
    func POST(apiTag tag:String, param parameters:[String: AnyObject]?, successBlock success:ClosureSuccess?, failureBlock failure:ClosureError?, internalheaders: HTTPHeaders? = nil) -> URLSessionTask?
    {
        let uRequest = SessionManager.default.request((BASEURL! + tag), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: internalheaders ?? headers)
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
            
            switch meta.valueForInt(key: CStatusCode) {
            case CStatus200:
                return true
            default:
                if showAlert {
                    let message = meta.valueForString(key: CJsonMessage)
//                    MIAlertController().present(CTopMostViewController, title: CMessageTitleAlert, message: message)
                }
            }
        }
        
        return false
    }
    
    
    func actionOnAPIFailure(errorMessage:String?, showAlert:Bool, strApiTag:String,error:NSError?) -> Void
    {
        if showAlert && errorMessage != nil
        {
//            MIAlertController().present(CTopMostViewController, title: "", message: appDelegate.fetchAppropriateMessage(key: errorMessage!))
        }
        
        print("API Error =" + "\(strApiTag )" + "\(String(describing: error?.localizedDescription))" )
    }
    
}



//MARK:- ---------API Functions

extension APIRequest {
    //TODO:
    //TODO: --------------GENERAL API--------------
    //TODO:
    
//    func generalSettings(completion: @escaping ClosureCompletion)
//    {
//        MIPangeaLoader.shared().showLoaderWithText(strTitle: CMessageGeneralSettings)
//        _ = Networking.sharedInstance.POST(apiTag: CAPITagGeneralSettings, param: nil, successBlock: { (task, response) in
//            MIPangeaLoader.shared().hideLoader()
//            completion(response, nil)
//            self.saveGeneralSettingsToLocal(dictSettings: response as! Dictionary<String, Any>)
//        }, failureBlock: { (task, message, error) in
//            MIPangeaLoader.shared().hideLoader()
//            completion(nil, error)
//        })
//    }
    
}
