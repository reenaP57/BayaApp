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
        
        GCDMainThread.asyncAfter(deadline: .now() + 2) {
            if IS_SIMULATOR{
                self.txtEmail.text = "krishna@gmail.com"
                self.txtPassword.text = "123456"
            }
        }
        
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
    
    func checkValidation (view : UIView,txtField : UITextField) {
        
    }
    
    @IBAction fileprivate func btnLoginClicked (sender : UIButton) {
        
       appDelegate.initHomeViewController()
        return
        
//        for objView in vwContent.subviews{
//            if  objView.isKind(of: UITextField.classForCoder()){
//                let txField = objView as? UITextField
//                txField?.hideValidationMessage(15.0)
//                txField?.resignFirstResponder()
//            }
//        }
//
//        self.view.layoutIfNeeded()
//
//        DispatchQueue.main.async {
        
            if (self.txtEmail.text?.isBlank)! {
                self.txtPassword.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailOrMobileMessage))
                
            } else if !(self.txtEmail.text?.isBlank)! {

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
                        appDelegate.initHomeViewController()
                    }
                    
                } else {
                    
                    if !(self.txtEmail.text?.isValidPhoneNo)! || ((self.txtEmail.text?.count)! > 10 || (self.txtEmail.text?.count)! < 10) {
                       self.txtPassword.hideValidationMessage(15.0)
                        self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidMobileMessage))
                    } else if (self.txtPassword.text?.isBlank)! {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,CBlankPasswordMessage))
                        
                    } else if !(self.txtPassword.text?.isValidPassword)! || (self.txtPassword.text?.count)! < 6  {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0, CInvalidPasswordMessage))
                    } else {
                        appDelegate.initHomeViewController()
                    }
                }
           // }
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
