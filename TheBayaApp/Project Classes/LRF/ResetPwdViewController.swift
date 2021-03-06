//
//  ResetPwdViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ResetPwdViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtCode : UITextField!
    @IBOutlet fileprivate weak var txtNewPwd : UITextField!
    @IBOutlet fileprivate weak var txtConfirmPwd : UITextField!
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var lblNote : UILabel!
    @IBOutlet fileprivate weak var imgVBg : UIImageView!

    var isEmail : Bool = false
    var strEmailMobile = ""
    var countryId = 0
    var verifyCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        self.title = "Reset Password"
        
        if IS_iPhone_6_Plus {
            _ = lblNote.setConstraintConstant(self.lblNote.CViewY + 10, edge: .top, ancestor: true)
        }
        
       strEmailMobile =  strEmailMobile.replacingOccurrences(of: "\"", with: "")
        
       lblNote.text = isEmail ? "\(CResetMessage) email address [\(strEmailMobile)]. Enter verification code in below." : "\(CResetMessage) mobile number [\(strEmailMobile)]. Enter verification code in below."
        
        if !isEmail {
             self.resendVerificationCode(type: CMobileType)
        }
    }
}

//MARK:-
//MARK:- UITextField Delegate

extension ResetPwdViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtCode:
            txtCode.hideValidationMessage(15.0)
        case txtNewPwd:
            txtNewPwd.hideValidationMessage(15.0)
        default:
            txtConfirmPwd.hideValidationMessage(15.0)
        }

        return true
    }
}


//MARK:-
//MARK:- Action

extension ResetPwdViewController {
    
    @IBAction fileprivate func btnResendCodeClicked (sender : UIButton) {
   
        if isEmail {
            self.resendVerificationCode(type: CEmailType)
        } else {
            self.resendVerificationCode(type: CMobileType)
        }
    }
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {

            if (self.txtCode.text?.isBlank)! {
                
                self.txtNewPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)

                self.vwContent.addSubview(self.txtCode.showValidationMessage(15.0, CBlankVerificationCodeMessage))
                
            } else if (self.txtCode.text?.count)! > 6 || (self.txtCode.text?.count)! < 6 {
                
                self.txtNewPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)
                
                self.vwContent.addSubview(self.txtCode.showValidationMessage(15.0, CInvalidVerificationCodeMessage))
                
            } else if (self.txtNewPwd.text?.isBlank)! {
                
                self.txtConfirmPwd.hideValidationMessage(15.0)
                
                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CBlankNewPasswordMessage))
                
            } else if !(self.txtNewPwd.text?.isValidPassword)! || (self.txtNewPwd.text?.count)! < 6  {
                
                self.txtConfirmPwd.hideValidationMessage(15.0)

                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CInvalidNewPasswordMessage))
                
            } else if (self.txtConfirmPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CBlankConfirmPasswordMessage))
            } else if self.txtConfirmPwd.text != self.txtNewPwd.text {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CMisMatchNewPasswordMessage))
            } else {
                self.resignKeyboard()
                self.resetPassword()
            }
      }
}


//MARK:-
//MARK:- API

extension ResetPwdViewController {
    
    func resendVerificationCode(type : Int) {
        self.resignKeyboard()
        
        var dict = [String : AnyObject]()
        
        if type == CMobileType {
            dict = ["type" : type as AnyObject,
                    "userName" : strEmailMobile as AnyObject,
                    CCountryId : countryId as AnyObject,
                    "sendSMS" : 1,
                    "deviceInfo" : ["platform" : "IOS",
                                    "deviceVersion" :appDelegate.deviceName,
                                    "deviceOS" : UIDevice.current.systemVersion,
                                    "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String]] as [String : AnyObject]
            
        } else {
            dict = ["type" : type as AnyObject,
                    "userName" : strEmailMobile as AnyObject,
                    "sendSMS" : 0,
                    "deviceInfo" : ["platform" : "IOS",
                                    "deviceVersion" :appDelegate.deviceName,
                                    "deviceOS" : UIDevice.current.systemVersion,
                                    "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String]] as [String : AnyObject]
        }
        
        APIRequest.shared().forgotPassword(dict: dict) { (response, error) in
            
            if response != nil && error == nil {

                self.imgVBg.isHidden = false
                self.showAlertView(self.isEmail ? "\(CResetCodeEmailMessage) [\(self.strEmailMobile)]." :"\(CResetCodeMobileMessage) [\(self.strEmailMobile)].", completion: { (result) in
                })
            } else {
                 self.imgVBg.isHidden = true
            }
        }
    }
    
    func resetPassword() {
        
        let dict = ["userName": strEmailMobile as AnyObject, "type": isEmail ? CEmailType : CMobileType, "password": txtConfirmPwd.text as AnyObject, "code":txtCode.text as AnyObject] as [String : AnyObject]
        
        APIRequest.shared().resetPassword(dict) { (response, error) in
            
            if response != nil && error == nil {
                 self.imgVBg.isHidden = false
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let message  = metaData.valueForString(key: CJsonMessage)
                
                self.showAlertView(message, completion: { (result) in
                    if result {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
            } else {
                 self.imgVBg.isHidden = true
            }
        }
    }
    
}
