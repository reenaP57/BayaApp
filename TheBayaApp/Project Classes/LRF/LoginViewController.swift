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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialize() {
        
    }
}



//MARK:-
//MARK:- Action

extension LoginViewController {
    
    @IBAction fileprivate func btnLoginClicked (sender : UIButton) {
        
    }
    
    @IBAction fileprivate func btnForgotPasswordClicked (sender : UIButton) {
        
        if let forgotPwdVC = CStoryboardLRF.instantiateViewController(withIdentifier: "ForgotPwdViewController") as? ForgotPwdViewController {
            self.navigationController?.pushViewController(forgotPwdVC, animated: true)
        }
    }

    @IBAction fileprivate func btnSignUpClicked (sender : UIButton) {
        
//        if let signupVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
//            self.navigationController?.pushViewController(signupVC, animated: true)
//        }
//
//        return
        
        for objView in vwContent.subviews{
            if  objView.isKind(of: UITextField.classForCoder()){
                let txField = objView as? UITextField
                txField?.hideValidationMessage(15.0)
                txField?.resignFirstResponder()
            }
        }
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            if self.txtEmail.text == "" {
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0,"Please enter first name."))
            } else if self.txtPassword.text == "" {
                self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,"Please enter last name"))
            } else {
                if let signupVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                    self.navigationController?.pushViewController(signupVC, animated: true)
                }
            }
        }
    }
    
    @IBAction fileprivate func btnRememberMeClicked (sender : UIButton) {
        btnRememberMe.isSelected = !btnRememberMe.isSelected
    }

}
