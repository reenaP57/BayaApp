//
//  SignUpViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SignUpViewController: ParentViewController {
    
    @IBOutlet fileprivate weak var txtFName : UITextField!
    @IBOutlet fileprivate weak var txtLName : UITextField!
    @IBOutlet fileprivate weak var txtEmail : UITextField!
    @IBOutlet fileprivate weak var txtCountryCode : UITextField!{
        didSet {
            txtCountryCode.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15)
        }
    }
    
    @IBOutlet fileprivate weak var txtMobile : UITextField!
    @IBOutlet fileprivate weak var txtPwd : UITextField!
    @IBOutlet fileprivate weak var txtConfirmPwd : UITextField!
    @IBOutlet fileprivate weak var btnRememberMe : UIButton!
    @IBOutlet fileprivate weak var btnTerms : UIButton!
    @IBOutlet fileprivate weak var vwContent : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialize() {
         self.title = "Sign up"
        
        txtCountryCode.setPickerData(arrPickerData: ["+91","+79","+63"], selectedPickerDataHandler: { (string, row, index) in
        }, defaultPlaceholder: "")
    }
    
}


//MARK:-
//MARK:- Action

extension SignUpViewController {
    
    @IBAction fileprivate func btnSignUpClicked (sender : UIButton) {
        
        for objView in vwContent.subviews{
            if  objView.isKind(of: UITextField.classForCoder()){
                let txField = objView as? UITextField
                txField?.hideValidationMessage(15.0)
                txField?.resignFirstResponder()
            }
        }
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            
            if (self.txtFName.text?.isBlank)! {
                self.vwContent.addSubview(self.txtFName.showValidationMessage(15.0, CBlankFirstNameMessage))
            } else if (self.txtLName.text?.isBlank)! {
                self.vwContent.addSubview(self.txtLName.showValidationMessage(15.0, CBlankLastNameMessage))
            } else if (self.txtEmail.text?.isBlank)! {
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailMessage))
            } else if !(self.txtEmail.text?.isValidEmail)! {
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidEmailMessage))
            } else if (self.txtMobile.text?.isBlank)! {
                self.vwContent.addSubview(self.txtMobile.showValidationMessage(15.0, CBlankMobileMessage))
            } else if !(self.txtMobile.text?.isValidPhoneNo)! {
                self.vwContent.addSubview(self.txtMobile.showValidationMessage(15.0, CInvalidMobileMessage))
            } else if (self.txtPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtPwd.showValidationMessage(15.0, CBlankPasswordMessage))
            } else if !(self.txtPwd.text?.isValidPassword)! {
                self.vwContent.addSubview(self.txtPwd.showValidationMessage(15.0, CInvalidPasswordMessage))
            } else if (self.txtConfirmPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CBlankConfirmPasswordMessage))
            } else if self.txtConfirmPwd.text != self.txtPwd.text {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CMisMatchPasswordMessage))
            } else if !self.btnTerms.isSelected {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CTermsConditionNotAcceptedMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else {
                if let verifyVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
                    self.navigationController?.pushViewController(verifyVC, animated: true)
                }
            }
            
        }
        
      
    }

    @IBAction fileprivate func btnTermsAndConditionClicked (sender : UIButton) {

    }
    
    @IBAction fileprivate func btnRememberMeClicked (sender : UIButton) {
        btnRememberMe.isSelected = !btnRememberMe.isSelected
    }
    
    @IBAction fileprivate func btnAcceptConditionClicked (sender : UIButton) {
        btnTerms.isSelected = !btnTerms.isSelected
    }

}
