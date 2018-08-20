//
//  LoginViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class LoginViewController: ParentViewController, UITextFieldDelegate {

    @IBOutlet fileprivate weak var txtEmail : UITextField!
    @IBOutlet fileprivate weak var txtPassword : UITextField!
    @IBOutlet fileprivate weak var btnRememberMe : UIButton!
    @IBOutlet fileprivate weak var vwContent : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        var rotationAndPerspectiveTransform = CATransform3D()
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(Double.pi * 0.6), 1.0, 0.0, 0.0)
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.txtEmail.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            self.txtEmail.layer.transform = rotationAndPerspectiveTransform
        }) { (finished) in
        }
    }
}



//MARK:-
//MARK:- Action

extension LoginViewController {
    
    @IBAction fileprivate func btnLoginClicked (sender : UIButton) {
        
       appDelegate.initHomeViewController()
        
        
        return
        
        
        for objView in vwContent.subviews{
            if  objView.isKind(of: UITextField.classForCoder()){
                let txField = objView as? UITextField
                txField?.hideValidationMessage(15.0)
                txField?.resignFirstResponder()
            }
        }
        
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            
            if (self.txtEmail.text?.isBlank)! {
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailOrMobileMessage))
                
            } else if !(self.txtEmail.text?.isBlank)! {
                
                if self.txtEmail.text?.range(of:"@") != nil || self.txtEmail.text?.rangeOfCharacter(from: CharacterSet.letters) != nil  {
                    
                    if !(self.txtEmail.text?.isValidEmail)! {
                        self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidEmailMessage))
                        
                    } else if (self.txtPassword.text?.isBlank)! {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,CBlankPasswordMessage))
                        
                    } else {
                        if let signupVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                            self.navigationController?.pushViewController(signupVC, animated: true)
                        }
                    }
                    
                } else {
                    
                    if (self.txtEmail.text?.isValidPhoneNo)! {
                        self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidMobileMessage))
                    } else if (self.txtPassword.text?.isBlank)! {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,CBlankPasswordMessage))
                        
                    } else {
                        if let signupVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                            self.navigationController?.pushViewController(signupVC, animated: true)
                        }
                    }
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
