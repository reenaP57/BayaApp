//
//  ForgotPwdViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ForgotPwdViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtEmail : UITextField!
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var lblNote : UILabel!

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
        self.title = "Forgot Password"
        
        if IS_iPhone_6_Plus {
            _ = lblNote.setConstraintConstant(self.lblNote.CViewY + 10, edge: .top, ancestor: true)
        }
    }
}

//MARK:-
//MARK:- UITextField Delegate

extension ForgotPwdViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        txtEmail.hideValidationMessage(50.0)
        return true
    }
}


//MARK:-
//MARK:- Action

extension ForgotPwdViewController {
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {
        
        if (self.txtEmail.text?.isBlank)! {
            self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailOrMobileMessage))
            
        } else if !(self.txtEmail.text?.isBlank)! {
            
            //...Email
            if self.txtEmail.text?.range(of:"@") != nil || self.txtEmail.text?.rangeOfCharacter(from: CharacterSet.letters) != nil  {
                
                if !(self.txtEmail.text?.isValidEmail)! {
                    self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidEmailMessage))
                    
                } else {
                    self.forgotPassword(type: CEmailType)
                }
                
            } else {
                
                //...Mobile
                if !(self.txtEmail.text?.isValidPhoneNo)! || ((self.txtEmail.text?.count)! > 10 || (self.txtEmail.text?.count)! < 10) {
                    self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidMobileMessage))
                } else {
                    self.forgotPassword(type: CMobileType)
                }
            }
        }
    }
}


//MARK:-
//MARK:- API

extension ForgotPwdViewController {
    
    func forgotPassword(type : Int) {
        self.resignKeyboard()
        
        APIRequest.shared().forgotPassword(txtEmail.text, type: type) { (response, error) in
            
            if response != nil && error == nil {
                
                if let resetPwdVC = CStoryboardLRF.instantiateViewController(withIdentifier: "ResetPwdViewController") as? ResetPwdViewController {
                    
                    if type == CEmailType {
                        resetPwdVC.isEmail = true
                    } else {
                        resetPwdVC.isEmail = false
                    }
                    
                    resetPwdVC.strEmailMobile = self.txtEmail.text!
                    self.navigationController?.pushViewController(resetPwdVC, animated: true)
                }
                
            }
        }
    }
}
