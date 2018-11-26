//
//  PayementViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 30/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class PayementViewController: ParentViewController {

    @IBOutlet weak var txtPwd : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
}


//MARK:-
//MARK:- Action

extension PayementViewController {
    
    @IBAction fileprivate func btnForgotPasswordClicked (sender : UIButton) {
        
        self.resignKeyboard()
        self.showAlertConfirmationView("The password for this section is the same as your app login password. In order to reset the password, you will have to sign out of the app, and select the forgot password option at the login screen. If you wish to proceed, you can click on the sign out button below.", okTitle: "Logout", cancleTitle: CBtnCancel, type: .confirmationView) { (result) in
            
            if result {
                appDelegate.logout(isForDeleteUser: false)
            }
        }
    }
    
    @IBAction fileprivate func btnEnterPasswordClicked (sender : UIButton) {
        
        self.resignKeyboard()
        if (txtPwd.text?.isBlank)! {
            self.view.addSubview(self.txtPwd.showValidationMessage(30.0, CBlankPassword))
        } else if !(self.txtPwd.text?.isValidPassword)! || (self.txtPwd.text?.count)! < 6 {
            self.view.addSubview(self.txtPwd.showValidationMessage(30.0, CInvalidPassword))
        } else {
            self.checkPassword()
        }
    }
}


//MARK:-
//MARK:- UITextFieldDelegate
extension PayementViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        txtPwd.hideValidationMessage(45.0)
        return true
    }
}


//MARK;-
//MARK:- API Methods
extension PayementViewController {

    func checkPassword() {
        
        APIRequest.shared().checkPasswordForPayment(password: txtPwd.text) { (response, error) in
            if response != nil {
                if let paymentScheduleVC = CStoryboardPayment.instantiateViewController(withIdentifier: "PaymentScheduleViewController") as? PaymentScheduleViewController {
                    self.navigationController?.pushViewController(paymentScheduleVC, animated: true)
                }
            }
        }
    }
}
