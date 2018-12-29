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
    @IBOutlet fileprivate weak var lblTermsCondtion : UILabel!

    var projectId : Int = 0
    
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
        lblOffer.text = MIGeneralsAPI.shared().strRefferalPoint
        lblTermsCondtion.text = MIGeneralsAPI.shared().strTermsConditionReferral
       // self.getReferralPoint()
        
        self.txtSelectProject.setPickerData(arrPickerData: MIGeneralsAPI.shared().arrProjectList.map({$0[CProjectName]! as! String}), selectedPickerDataHandler: { (string, row, index) in
            self.txtSelectProject.hideValidationMessage(45)
            self.projectId = MIGeneralsAPI.shared().arrProjectList[row].valueForInt(key: CProjectId)!
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
            self.vwContent.addSubview(self.txtPhone.showValidationMessage(15.0, CBlankMobileMessage))
            
        } else if (txtPhone.text?.count)! > 10 || (txtPhone.text?.count)! < 10 {
            self.txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtPhone.showValidationMessage(15.0, CValidPhone))
            
        } else if !self.btnTermsCondition.isSelected {
            self.showAlertView(CAcceptTermsCondition, completion: nil)
            
        } else {
           self.postReferralFriendDetail()
        }
    }
    
    @IBAction func btnAcceptTermsCondition (sender : UIButton) {
        btnTermsCondition.isSelected = !btnTermsCondition.isSelected
    }
}


//MARK:-
//MARK:- UITextFieldDelegate

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


//MARK:-
//MARK:- API Methods

extension ReferFriendViewController {
    
    func getReferralPoint() {
        
        APIRequest.shared().getReferralPoint { (response, error) in
            if response != nil {
                if let responseData = response?.value(forKey: CJsonData) as? [String : AnyObject] {
                    self.lblOffer.text = "\(responseData.valueForString(key: "referralPoint"))%"
                }
            }
        }
    }
    
    func postReferralFriendDetail() {
        
        let dict = ["name" : txtReferredName.text as Any,
                    "email" : txtEmail.text as Any,
                    "phone" : txtPhone.text as Any,
                    "projectId" : projectId] as [String : AnyObject]
        
        APIRequest.shared().referralFriend(dict: dict) { (response, error) in
            
            if  response != nil {
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    self.showAlertView(metaData.valueForString(key: CJsonMessage), completion: { (result) in
                        if result {
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }
        }
    }
}
