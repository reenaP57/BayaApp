//
//  ChangePasswordViewController.swift
//  TheBayaApp
//
//  Created by Mac-0008 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ChangePasswordViewController: ParentViewController {
    
    @IBOutlet weak var txtCurrentPwd: UITextField!
    @IBOutlet weak var txtNewPwd: UITextField!
    @IBOutlet weak var txtConfirmPwd: UITextField!
    @IBOutlet weak var vwContent: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "Change Password"
    }
}


//MARK:-
//MARK:- Action Methods

extension ChangePasswordViewController {
    
    @IBAction func btnSubmitClicked(_ sender: UIButton) {
        
        for objView in vwContent.subviews{
            if  objView.isKind(of: UITextField.classForCoder()){
                let txField = objView as? UITextField
                txField?.hideValidationMessage(15.0)
                txField?.resignFirstResponder()
            }
        }
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
        
            if (self.txtCurrentPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtCurrentPwd.showValidationMessage(15.0, CBlankOldPasswordMessage))
                
            } else if (self.txtNewPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CBlankNewPasswordMessage))
                
            } else if !(self.txtNewPwd.text?.isValidPassword)! {
                self.vwContent.addSubview(self.txtNewPwd.showValidationMessage(15.0, CInvalidPasswordMessage))
                
            } else if (self.txtConfirmPwd.text?.isBlank)! {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CBlankConfirmPasswordMessage))
                
            } else if self.txtConfirmPwd.text != self.txtNewPwd.text {
                self.vwContent.addSubview(self.txtConfirmPwd.showValidationMessage(15.0, CMisMatchPasswordMessage))
                
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
