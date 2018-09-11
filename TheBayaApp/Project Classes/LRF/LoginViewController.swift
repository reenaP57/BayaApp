//
//  LoginViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit



class LoginViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtEmail : UITextField!
    @IBOutlet fileprivate weak var txtPassword : UITextField!
    @IBOutlet fileprivate weak var btnRememberMe : UIButton!
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var lblSignUp : UILabel!

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
        
        self.setAtttibuteString()
    }
    
    func setAtttibuteString() {
        
        let attributedString = NSMutableAttributedString(string: "New user? Sign Up")
        attributedString.addAttributes([
            .font: CFontAvenir(size:IS_iPhone ? 13.0 : 18.0, type: .heavy).setUpAppropriateFont()!,
            .foregroundColor: ColorGreenSelected
            ], range: NSRange(location: 10, length: 7))
        
        lblSignUp.attributedText = attributedString
    }
}


// MARK:- -------- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtEmail:
            txtEmail.hideValidationMessage(15.0)
        default:
            txtPassword.hideValidationMessage(15.0)
            let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }

        return true
    }
}


//MARK:-
//MARK:- Action

extension LoginViewController {
    
    @IBAction fileprivate func btnLoginClicked (sender : UIButton) {
        
            if (self.txtEmail.text?.isBlank)! {
                self.txtPassword.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailOrMobileMessage))
                
            } else if !(self.txtEmail.text?.isBlank)! {
                
                //...Email
                if self.txtEmail.text?.range(of:"@") != nil || self.txtEmail.text?.rangeOfCharacter(from: CharacterSet.letters) != nil  {
                    
                    if !(self.txtEmail.text?.isValidEmail)! {
                        self.txtPassword.hideValidationMessage(15.0)
                        self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidEmailMessage))
                        
                    } else if (self.txtPassword.text?.isBlank)! {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,CBlankPasswordMessage))
                        
                    } else if !(self.txtPassword.text?.isValidPassword)! || (self.txtPassword.text?.count)! < 6 {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0, CInvalidPasswordMessage))
                    }
                    else {
                        self.login(type: CEmailType)
                    }
                    
                } else {
                    //...Mobile Number
                    
                    if !(self.txtEmail.text?.isValidPhoneNo)! || ((self.txtEmail.text?.count)! > 10 || (self.txtEmail.text?.count)! < 10) {
                       self.txtPassword.hideValidationMessage(15.0)
                        self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidMobileMessage))
                    } else if (self.txtPassword.text?.isBlank)! {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,CBlankPasswordMessage))
                        
                    } else if !(self.txtPassword.text?.isValidPassword)! || (self.txtPassword.text?.count)! < 6  {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0, CInvalidPasswordMessage))
                    } else {
                       self.login(type: CMobileType)
                    }
                }
        }
    }
    
    @IBAction fileprivate func btnForgotPasswordClicked (sender : UIButton) {
        
        if let forgotPwdVC = CStoryboardLRF.instantiateViewController(withIdentifier: "ForgotPwdViewController") as? ForgotPwdViewController {
            self.navigationController?.pushViewController(forgotPwdVC, animated: true)
        }
    }

    @IBAction fileprivate func btnSignUpClicked (sender : UIButton) {
        
        if let signupVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    @IBAction fileprivate func btnRememberMeClicked (sender : UIButton) {
        btnRememberMe.isSelected = !btnRememberMe.isSelected
    }

}


//MARK:-
//MARK:- API

extension LoginViewController {
    
    func login(type : Int) {
        
        self.resignKeyboard()
        
        APIRequest.shared().loginUser(txtEmail.text, txtPassword.text, type) { (response, error) in
            
            if response != nil && error == nil {
                
                print("Response : ",response as Any)
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let message  = metaData.valueForString(key: CJsonMessage)
                let status = metaData.valueForInt(key: CJsonStatus)
                
                if status == CStatusFour {
                    
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                        
                        if let verifyVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
                            
                            if dataResponse.valueForInt(key: "emailVerify") == 0 {
                                verifyVC.isEmailVerify = true
                            }
                            self.navigationController?.pushViewController(verifyVC, animated: true)
                        }
                    })
                    
                } else {
                    if self.btnRememberMe.isSelected && (appDelegate.loginUser?.mobileVerify)! && (appDelegate.loginUser?.emailVerify)! {
                         CUserDefaults.set(true, forKey: UserDefaultRememberMe)
                    }
                    
                   appDelegate.initHomeViewController()
                }
            }
        }
    }
    
}
