//
//  VerificationViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 08/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class VerificationViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtCode : UITextField!
    @IBOutlet fileprivate weak var lblNote : UILabel!
    @IBOutlet fileprivate weak var vwContent : UIView!

    var isFromSignUp : Bool = false

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
        
        if IS_iPhone_6_Plus {
          _ = lblNote.setConstraintConstant(self.lblNote.CViewY + 10, edge: .top, ancestor: true)
        }
        
        
        if isFromSignUp {
            //...Verify Email
            
            self.title = "Verity Email"
            self.lblNote.text = "\(CVerifyNoteMessage) email address [abc@gmail.com]"
            
        } else {
            //...Verify Mobile Number
            
            self.title = "Verity Mobile Number"
            self.lblNote.text = "\(CVerifyNoteMessage) mobile number [+1234567890]"
        }
    }

}


//MARK:-
//MARK:- Action

extension VerificationViewController {
    
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
                self.vwContent.addSubview(self.txtCode.showValidationMessage(15.0, CBlankVerificationCodeMessage))
            } else if (self.txtCode.text?.count)! > 6 || (self.txtCode.text?.count)! < 6 {
                self.vwContent.addSubview(self.txtCode.showValidationMessage(15.0, CInvalidVerificationCodeMessage))
            } else {
                if self.isFromSignUp {
                    
                    if let verifyMobileVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
                        self.navigationController?.pushViewController(verifyMobileVC, animated: true)
                    }
                    
                } else {
                    appDelegate.initHomeViewController()
                }
            }
        }
    }
    
    @IBAction fileprivate func btnResendVerificationCodeClicked (sender : UIButton) {
        
    }
}
