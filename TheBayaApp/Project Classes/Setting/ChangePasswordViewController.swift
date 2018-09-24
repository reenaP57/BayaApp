//
//  ChangePasswordViewController.swift
//  TheBayaApp
//
//  Created by Mac-0008 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ParentViewController {
    
    @IBOutlet weak var txtCurrentPwd: UITextField!
    @IBOutlet weak var txtNewPwd: UITextField!
    @IBOutlet weak var txtConfirmPwd: UITextField!
    @IBOutlet weak var vwContent: UIView!

    var isFromLogin : Bool = false
    var isRememberMe : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "Change Password"
    }
}

//MARK:-
//MARK:- UITextField Delegate

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtCurrentPwd:
            txtCurrentPwd.hideValidationMessage(15.0)
        case txtNewPwd:
            txtNewPwd.hideValidationMessage(15.0)
        default:
            txtConfirmPwd.hideValidationMessage(15.0)
        }
        
        return true
    }
}


//MARK:-
//MARK:- Action Methods

extension ChangePasswordViewController {
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {

        if (self.txtCurrentPwd.text?.isBlank)! {
            
            self.txtNewPwd.hideValidationMessage(15.0)
            self.txtConfirmPwd.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtCurrentPwd.showValidationMessage(15.0, CBlankCurrentPasswordMessage))
            
        } else if (self.txtNewPwd.text?.isBlank)! {
            
            self.txtConfirmPwd.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CBlankNewPasswordMessage))
            
        } else if !(self.txtNewPwd.text?.isValidPassword)! || (self.txtNewPwd.text?.count)! < 6  {
            
            self.txtConfirmPwd.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CInvalidPasswordMessage))
            
        } else if (self.txtConfirmPwd.text?.isBlank)! {
            self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CBlankConfirmPasswordMessage))
            
        } else if self.txtConfirmPwd.text != self.txtNewPwd.text {
            self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CMisMatchPasswordMessage))
            
        } else {
            self.resignKeyboard()
            self.changePassword()
        }
    }
}


//MARK:-
//MARK:- API

extension ChangePasswordViewController {
    
    func changePassword() {
        
        APIRequest.shared().changePassword(txtCurrentPwd.text, txtConfirmPwd.text) { (response, error) in
            
            if response != nil && error == nil {
                
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let message  = metaData.valueForString(key: CJsonMessage)
                
                if self.isFromLogin {
                    
                    if self.isRememberMe && (appDelegate.loginUser?.mobileVerify)! && (appDelegate.loginUser?.emailVerify)! {
                        CUserDefaults.set(true, forKey: UserDefaultRememberMe)
                        CUserDefaults.synchronize()
                    }
                    appDelegate.initHomeViewController()
                    
                } else {
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
}
