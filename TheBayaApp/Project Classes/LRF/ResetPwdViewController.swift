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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initialize() {
        self.title = "Reset Password"
    }
}


//MARK:-
//MARK:- Action

extension ResetPwdViewController {
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {
        
        
        for objView in vwContent.subviews{
            if  objView.isKind(of: UITextField.classForCoder()){
                let txField = objView as? UITextField
                txField?.hideValidationMessage(15.0)
                txField?.resignFirstResponder()
            }
        }
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            
            if (self.txtCode.text?.isBlank)! {
                self.vwContent.addSubview(self.txtCode.showValidationMessage(15.0, CBlankOTPMessage))
            } else if (self.txtNewPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CBlankPasswordMessage))
            } else if !(self.txtNewPwd.text?.isValidPassword)! {
                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CInvalidPasswordMessage))
            } else if (self.txtConfirmPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CBlankConfirmPasswordMessage))
            } else if self.txtConfirmPwd.text != self.txtNewPwd.text {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CMisMatchPasswordMessage))
            }
        }
        
    }
    
}
