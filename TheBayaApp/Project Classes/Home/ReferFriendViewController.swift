//
//  ReferFriendViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 31/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ReferFriendViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtReferredName : UITextField!
    @IBOutlet fileprivate weak var txtEmail : UITextField!
    @IBOutlet fileprivate weak var txtPhone : UITextField!
    @IBOutlet fileprivate weak var txtSelectProject : UITextField!{
        didSet {
            txtSelectProject.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var lblOffer : UILabel!
    @IBOutlet fileprivate weak var btnTermsCondition : UIButton!
    @IBOutlet fileprivate weak var vwContent : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title = "Refer a Friend"
        
        txtSelectProject.setPickerData(arrPickerData: ["Project1","Project2","Project3"], selectedPickerDataHandler: { (title, row, component) in
            self.txtSelectProject.hideValidationMessage(15.0)
        }, defaultPlaceholder: "")
    }
}


//MARK:-
//MARK:- Action

extension ReferFriendViewController {
    
    @IBAction func btnSendClicked (sender : UIButton) {
        
        if (self.txtReferredName.text?.isBlank)! {
            self.txtEmail.hideValidationMessage(15.0)
            self.txtPhone.hideValidationMessage(15.0)
            self.txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtReferredName.showValidationMessage(15.0, CBlankReferredName))
            
        } else if (self.txtEmail.text?.isBlank )!{
            self.txtPhone.hideValidationMessage(15.0)
            self.txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankReferEmail))
            
        } else if !(self.txtEmail.text?.isValidEmail)!{
            self.txtPhone.hideValidationMessage(15.0)
            self.txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CValidEmailForRefer))
            
        } else if (self.txtPhone.text?.isBlank)!{
            self.txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtPhone.showValidationMessage(15.0, CBlankReferPhone))
            
        } else if (txtPhone.text?.count)! > 10 || (txtPhone.text?.count)! < 10 {
            self.txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtPhone.showValidationMessage(15.0, CValidPhone))
            
        } else if !self.btnTermsCondition.isSelected {
            self.showAlertView(CAcceptTermsCondition, completion: nil)
            
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnAcceptTermsCondition (sender : UIButton) {
        btnTermsCondition.isSelected = !btnTermsCondition.isSelected
    }
}


// MARK:- -------- UITextFieldDelegate
extension ReferFriendViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case txtReferredName:
            txtReferredName.hideValidationMessage(15.0)
        case txtEmail:
            txtEmail.hideValidationMessage(15.0)
        case txtPhone:
            txtPhone.hideValidationMessage(15.0)
        default:
            print("")
        }
        return true
    }
}
