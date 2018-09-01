//
//  EditProfileViewController.swift
//  TheBayaApp
//
//  Created by Mac-0008 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class EditProfileViewController: ParentViewController {

    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblSupport: UILabel!


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
        self.title = "Edit Profile"
        
        txtMail.backgroundColor = ColorDisableTextField
        txtState.backgroundColor = ColorDisableTextField
        txtMobileNumber.backgroundColor = ColorDisableTextField
        
        self.setAtttibuteString()
    }
    
    func setAtttibuteString() {
        
        let attributedString = NSMutableAttributedString(string: "If you want to change your email ID or phone number, create a support request.")
        attributedString.addAttributes([
            .font: CFontAvenir(size:IS_iPhone ? 13.0 : 19.0, type: .heavy).setUpAppropriateFont()!,
            .foregroundColor: ColorGreenSelected
            ], range: NSRange(location: 62, length: 15))
        
        lblSupport.attributedText = attributedString
    }
    
}


//MARK:-
//MARK:- UITextField Delegate

extension EditProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtFName:
            txtFName.hideValidationMessage(15.0)
        default:
            txtLName.hideValidationMessage(15.0)
        }
        
        return true
    }
}



//MARK:-
//MARK:- Action Methods

extension EditProfileViewController {
    
    @IBAction func btnSupportRequestCilcked(_ sender: UIButton) {
        if let supportVC = CStoryboardSetting.instantiateViewController(withIdentifier: "SupportViewController") as? SupportViewController {
            self.navigationController?.pushViewController(supportVC, animated: true)
        }
    }
    
    @IBAction func btnUpdateCilcked(_ sender: UIButton) {
        
//        for objView in vwContent.subviews{
//            if  objView.isKind(of: UITextField.classForCoder()){
//                let txField = objView as? UITextField
//                txField?.hideValidationMessage(15.0)
//                txField?.resignFirstResponder()
//            }
//        }
//        self.view.layoutIfNeeded()
//
//        DispatchQueue.main.async {
//
            if (self.txtFName.text?.isBlank)! {
                
                self.txtLName.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtFName.showValidationMessage(15.0, CBlankFirstNameMessage))
                
            } else if (self.txtLName.text?.isBlank)! {
                self.vwContent.addSubview(self.txtLName.showValidationMessage(15.0, CBlankLastNameMessage))
                
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    //}

}
