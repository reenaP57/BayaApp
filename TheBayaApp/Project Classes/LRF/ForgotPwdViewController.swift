//
//  ForgotPwdViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ForgotPwdViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtEmail : UITextField!
    @IBOutlet fileprivate weak var vwContent : UIView!
    
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
        self.title = "Forgot Password"
    }
}


//MARK:-
//MARK:- Action

extension ForgotPwdViewController {
    
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
            
            if (self.txtEmail.text?.isBlank)! {
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailMessage))
            } else if !(self.txtEmail.text?.isValidEmail)! {
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidEmailMessage))
            } else {
                
                if let resetPwdVC = CStoryboardLRF.instantiateViewController(withIdentifier: "ResetPwdViewController") as? ResetPwdViewController {
                    self.navigationController?.pushViewController(resetPwdVC, animated: true)
                }
            }
        }
    }
}
