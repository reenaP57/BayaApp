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
    @IBOutlet fileprivate weak var txtCountryCode : UITextField!{
        didSet {
            txtCountryCode.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15)
        }
    }
    
    @IBOutlet fileprivate weak var txtMobile : UITextField!
    @IBOutlet fileprivate weak var txtPwd : UITextField!
    @IBOutlet fileprivate weak var txtConfirmPwd : UITextField!
    @IBOutlet fileprivate weak var btnRememberMe : UIButton!
    @IBOutlet fileprivate weak var btnTerms : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initialize() {
         self.title = "Sign up"
        
        txtCountryCode.setPickerData(arrPickerData: ["+91","+79","+63"], selectedPickerDataHandler: { (string, row, index) in
        }, defaultPlaceholder: "")
    }
    
}


//MARK:-
//MARK:- Action

extension SignUpViewController {
    
    @IBAction fileprivate func btnSignUpClicked (sender : UIButton) {
        
        if let verifyVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
            self.navigationController?.pushViewController(verifyVC, animated: true)
        }
    }

    @IBAction fileprivate func btnTermsAndConditionClicked (sender : UIButton) {

    }
    
    @IBAction fileprivate func btnRememberMeClicked (sender : UIButton) {
        btnRememberMe.isSelected = !btnRememberMe.isSelected
    }
    
    @IBAction fileprivate func btnAcceptConditionClicked (sender : UIButton) {
        btnTerms.isSelected = !btnTerms.isSelected
    }

}
