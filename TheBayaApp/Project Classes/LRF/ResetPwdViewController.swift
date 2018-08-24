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
                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CBlankNewPasswordMessage))
            } else if !(self.txtNewPwd.text?.isValidPassword)! || (self.txtNewPwd.text?.count)! < 6  {
                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CInvalidNewPasswordMessage))
            } else if (self.txtConfirmPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CBlankConfirmPasswordMessage))
            } else if self.txtConfirmPwd.text != self.txtNewPwd.text {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CMisMatchNewPasswordMessage))
            } else {
                
                if let loginVC = CStoryboardLRF.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
        }
        
    }
    
}
