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
        self.title = "Verity Mobile Number"
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
            } else {
                
            }
        }
    }
    
    @IBAction fileprivate func btnResendVerificationCodeClicked (sender : UIButton) {
        
    }
}
