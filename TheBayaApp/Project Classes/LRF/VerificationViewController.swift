//
//  VerificationViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class VerificationViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtCode : UITextField!
    @IBOutlet fileprivate weak var lblNote : UILabel!
    @IBOutlet fileprivate weak var vwContent : UIView!

    var isEmailVerify : Bool = false
    var verifiyCode = ""

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
        
        if IS_iPhone_6_Plus {
          _ = lblNote.setConstraintConstant(self.lblNote.CViewY + 10, edge: .top, ancestor: true)
        }
        
        txtCode.text = verifiyCode
        
        if isEmailVerify {
            //...Verify Email
            
            self.title = "Verify Email"
            
            let email = appDelegate.loginUser?.email
            self.lblNote.text = "\(CVerifyNoteMessage) email address [\(email!)]."
            
        } else {
            //...Verify Mobile Number
            
            self.title = "Verify Mobile Number"
            self.lblNote.text = "\(CVerifyNoteMessage) mobile number [\((appDelegate.loginUser?.country_code)!) | \((appDelegate.loginUser?.mobileNo)!)]."
        }
    }

}


//MARK:-
//MARK:- UITextField Delegate

extension VerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtCode {
            txtCode.hideValidationMessage(50.0)
        }
        return true
    }
}


//MARK:-
//MARK:- Action

extension VerificationViewController {
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {
        
        if (self.txtCode.text?.isBlank)! {
            self.vwContent.addSubview(self.txtCode.showValidationMessage(15.0, CBlankVerificationCodeMessage))
        } else if (self.txtCode.text?.count)! > 6 || (self.txtCode.text?.count)! < 6 {
            self.vwContent.addSubview(self.txtCode.showValidationMessage(15.0, CInvalidVerificationCodeMessage))
        } else {
            
            var dict = [String : AnyObject]()
            
            if self.isEmailVerify {
                dict = [CEmail : (appDelegate.loginUser?.email)!,
                        "code" : self.txtCode.text as Any,
                        "type" : CEmailType] as [String : AnyObject]
            } else {
                dict = [CEmail : (appDelegate.loginUser?.email)!,
                        CMobileNo : (appDelegate.loginUser?.mobileNo)!,
                        "code" : self.txtCode.text as Any,
                        "type" : CMobileType] as [String : AnyObject]
            }
            self.resignKeyboard()
            self.verifyUser(param: dict)
        }
    }
    
    @IBAction fileprivate func btnResendVerificationCodeClicked (sender : UIButton) {
       
        if self.isEmailVerify {
            self.resendVerificationCode(dict: [CEmail : (appDelegate.loginUser?.email)! as AnyObject,"type" : CEmailType as AnyObject])
        } else {
            self.resendVerificationCode(dict: [CEmail : (appDelegate.loginUser?.email)! as AnyObject, CMobileNo : (appDelegate.loginUser?.mobileNo)! as AnyObject,"type" : CMobileType as AnyObject, CCountryId : (appDelegate.loginUser?.countryId)! as AnyObject])
        }
        
    }
}


//MARK:-
//MARK:- API

extension VerificationViewController {
    
    func verifyUser(param: [String : AnyObject]) {
        
        APIRequest.shared().verifyUser(param) { (response, error) in
            
            if response != nil && error == nil {
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]

                if self.isEmailVerify {
                    
                    if let verifyMobileVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
                        verifyMobileVC.verifiyCode = dataResponse.valueForString(key: "verifyCode")
                        self.navigationController?.pushViewController(verifyMobileVC, animated: true)
                    }
                    
                } else {
                    appDelegate.initHomeViewController()
                }
            }
        }
    }
    
    func resendVerificationCode(dict : [String : AnyObject]) {
        
        APIRequest.shared().resendVerificationCode(dict) { (response, error) in
            
            if response != nil && error == nil {
             
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]

                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let message  = metaData.valueForString(key: CJsonMessage)
                
                self.txtCode.text = dataResponse.valueForString(key: "verifyCode")
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                })
            }
        }
    }
}
