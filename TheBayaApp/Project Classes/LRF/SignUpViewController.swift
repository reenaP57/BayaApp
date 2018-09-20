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
    @IBOutlet fileprivate weak var txtCountryCode : UITextField!
    @IBOutlet fileprivate weak var txtMobile : UITextField!
    @IBOutlet fileprivate weak var txtPwd : UITextField!
    @IBOutlet fileprivate weak var txtConfirmPwd : UITextField!
    @IBOutlet fileprivate weak var btnRememberMe : UIButton!
    @IBOutlet fileprivate weak var btnTerms : UIButton!
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var lblTerms : UILabel!

    var countryID : Int = 356 //India country ID

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
        self.title = "Sign Up"
        
        self.setCountryList()
        self.setAttributeString()
    }
    
    func setCountryList(){
        
        let arrCountry = TblCountryList.fetch(predicate: nil, orderBy: "country_name", ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_with_code") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            
            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { (select, index, component) in
                
                let dict = arrCountry![index] as AnyObject
                countryID = dict.value(forKey: "country_id") as! Int
                txtCountryCode.text = "+\(dict.value(forKey: "country_code") ?? "")"
            }, defaultPlaceholder: "+91")
        }
    }
    
    func setAttributeString(){
        
        let attributedString = NSMutableAttributedString(string: "I Agree with the Terms & Conditions for the Baya App.")
        attributedString.addAttributes([
            .font: CFontAvenir(size: IS_iPhone ? 13.0 : 17.0, type: .heavy).setUpAppropriateFont()!,
            .foregroundColor: ColorGreenSelected
            ], range: NSRange(location: 17, length: 18))
        
        lblTerms.attributedText = attributedString
    }
    
}

// MARK:- -------- UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtFName:
            txtFName.hideValidationMessage(15.0)
        case txtLName:
            txtLName.hideValidationMessage(15.0)
        case txtEmail:
            txtEmail.hideValidationMessage(15.0)
        case txtMobile:
            txtMobile.hideValidationMessage(15.0)
        case txtPwd:
            txtPwd.hideValidationMessage(15.0)
            return self.checkPasswordValidation(string: string)
        default:
            txtConfirmPwd.hideValidationMessage(15.0)
            return checkPasswordValidation(string: string)
        }
     
        return true
    }
    
    func checkPasswordValidation(string : String) -> Bool {
        let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        return (string == filtered)
    }
}


//MARK:-
//MARK:- Action

extension SignUpViewController {
    
    @IBAction fileprivate func btnSignUpClicked (sender : UIButton) {

        DispatchQueue.main.async {
        
            if (self.txtFName.text?.isBlank)! {
                
                self.txtLName.hideValidationMessage(15.0)
                self.txtEmail.hideValidationMessage(15.0)
                self.txtMobile.hideValidationMessage(15.0)
                self.txtPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)

                self.vwContent.addSubview(self.txtFName.showValidationMessage(15.0, CBlankFirstNameMessage))
            } else if (self.txtLName.text?.isBlank)! {
                
                self.txtEmail.hideValidationMessage(15.0)
                self.txtMobile.hideValidationMessage(15.0)
                self.txtPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)
                
                self.vwContent.addSubview(self.txtLName.showValidationMessage(15.0, CBlankLastNameMessage))
                
            } else if (self.txtEmail.text?.isBlank)! {
                
                self.txtMobile.hideValidationMessage(15.0)
                self.txtPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailMessage))
                
            } else if !(self.txtEmail.text?.isValidEmail)! {
                
                self.txtMobile.hideValidationMessage(15.0)
                self.txtPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)
                
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidEmailMessage))
                
            } else if (self.txtMobile.text?.isBlank)! {
                
                self.txtPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtMobile.showValidationMessage(15.0, CBlankMobileMessage))
                
            } else if !(self.txtMobile.text?.isValidPhoneNo)! || ((self.txtMobile.text?.count)! > 10 || (self.txtMobile.text?.count)! < 10) {
                
                self.txtPwd.hideValidationMessage(15.0)
                self.txtConfirmPwd.hideValidationMessage(15.0)
                
                self.vwContent.addSubview(self.txtMobile.showValidationMessage(15.0, CInvalidMobileMessage))
            } else if (self.txtPwd.text?.isBlank)! {
                
                self.txtConfirmPwd.hideValidationMessage(15.0)
                
                self.vwContent.addSubview(self.txtPwd.showValidationMessage(15.0, CBlankPasswordMessage))
            } else if !(self.txtPwd.text?.isValidPassword)! || (self.txtPwd.text?.count)! < 6 {
                
                self.txtConfirmPwd.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtPwd.showValidationMessage(15.0, CInvalidPasswordMessage))
                
            } else if (self.txtConfirmPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CBlankConfirmPasswordMessage))
            } else if self.txtConfirmPwd.text != self.txtPwd.text {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CMisMatchPasswordMessage))
            } else if !self.btnTerms.isSelected {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CTermsConditionNotAcceptedMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else {
                self.resignKeyboard()
                self.signup()
            }
        }
    }

    @IBAction fileprivate func btnTermsAndConditionClicked (sender : UIButton) {

        if IS_iPad {
            if let cmsVC = CStoryboardSettingIphone.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                cmsVC.cmsEnum = .TermsCondition
                self.navigationController?.pushViewController(cmsVC, animated: true)
            }
            
        } else {
            if let termsConditionVC = CStoryboardSetting.instantiateViewController(withIdentifier: "CMSViewController") as? CMSViewController {
                termsConditionVC.cmsEnum = .TermsCondition
                self.navigationController?.pushViewController(termsConditionVC, animated: true)
            }
        }
    }
    
    @IBAction fileprivate func btnRememberMeClicked (sender : UIButton) {
        btnRememberMe.isSelected = !btnRememberMe.isSelected
        
        if btnRememberMe.isSelected {
            CUserDefaults.set(true, forKey: UserDefaultRememberMe)
        } else {
            CUserDefaults.set(nil, forKey: UserDefaultRememberMe)
        }

        CUserDefaults.synchronize()
    }
    
    @IBAction fileprivate func btnAcceptConditionClicked (sender : UIButton) {
        btnTerms.isSelected = !btnTerms.isSelected
    }

}

//MARK:-
//MARK:- API

extension SignUpViewController {
    
    func signup() {
        
        let dict = [CFirstName : txtFName.text as Any,
                    CLastName : txtLName.text as Any,
                    CEmail : txtEmail.text as Any,
                    CMobileNo : txtMobile.text as Any,
                    CPassword : txtPwd.text as Any,
                    CCountryId : countryID] as [String : AnyObject]
        
        APIRequest.shared().signUpUser(_dict: dict) { (response, error) in
            
            if response != nil && error == nil {
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]

                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let message  = metaData.valueForString(key: CJsonMessage)
                let status = metaData.valueForInt(key: CJsonStatus)
                
                if status == CStatusFour {
                    
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                       self.navigateToVerification(code : dataResponse.valueForString(key: "verifyCode"))
                    })
                    
                } else {
                    self.navigateToVerification(code : dataResponse.valueForString(key: "verifyCode"))
                }
                
                print("Response :",response as Any)
            }
        }
    }
    
    func navigateToVerification(code : String) {
        
        if let verifyVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
            verifyVC.isEmailVerify = true
            verifyVC.verifiyCode = code
            self.navigationController?.pushViewController(verifyVC, animated: true)
        }
    }
}
