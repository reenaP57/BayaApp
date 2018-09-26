//
//  ForgotPwdViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ForgotPwdViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtEmail : UITextField!{
        didSet{
            txtEmail.addLeftImageAsLeftView(strImgName: nil, leftPadding: 15.0)
        }
    }

    @IBOutlet fileprivate weak var txtCountryCode : UITextField!{
        didSet{
            txtCountryCode.addLeftImageAsLeftView(strImgName: nil, leftPadding: 7.0)
        }
    }
    
    @IBOutlet fileprivate weak var vwEmail : UIView!
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var lblNote : UILabel!
    @IBOutlet fileprivate weak var vwSeprater : UIView!
    
    var countryID : Int = 356 //India country ID
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CForgotPasswordScreenName)
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "Forgot Password"
        
        txtEmail.font = txtEmail.font?.setUpAppropriateFont()
        txtCountryCode.font = txtCountryCode.font?.setUpAppropriateFont()

        txtEmail.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        self.showValidation(isAdd: false)
        txtCountryCode.hide(byWidth: true)
        vwSeprater.isHidden = true
        
        self.setCountryList()
        
        if IS_iPhone_6_Plus {
            _ = lblNote.setConstraintConstant(self.lblNote.CViewY + 10, edge: .top, ancestor: true)
        }
    }
    
    func showValidation(isAdd : Bool){
        
        self.txtEmail.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
        self.txtEmail.layer.masksToBounds = true
        txtEmail.layer.cornerRadius = 5
        txtCountryCode.layer.cornerRadius = 5
        
        if isAdd {
            txtCountryCode.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            txtEmail.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            vwEmail.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
            vwEmail.layer.borderWidth = 1.0
            vwEmail.layer.borderColor = CRGB(r: 247, g: 51, b: 52).cgColor
            
        } else {
            vwEmail.layer.borderWidth = 0.0
            vwEmail.layer.borderColor = UIColor.white.cgColor
            txtCountryCode.backgroundColor = UIColor.white
            txtEmail.backgroundColor = UIColor.white
            vwEmail.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
        }
    }
    
    func setCountryList(){
        
        let arrCountry = TblCountryList.fetch(predicate: nil, orderBy: "country_name", ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_with_code") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            
            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { (select, index, component) in
                
                let dict = arrCountry![index] as AnyObject
                self.countryID = dict.value(forKey: "country_id") as! Int
                self.txtCountryCode.text = "+\(dict.value(forKey: "country_code") ?? "")"
            }, defaultPlaceholder: "+91")
        }
    }
}

//MARK:-
//MARK:- UITextField Delegate

extension ForgotPwdViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if textField == txtEmail {
            
            txtEmail.hideValidationMessage(50.0)
            self.showValidation(isAdd: false)
            
            if (txtEmail.text?.isValidPhoneNo)! && !(self.txtEmail.text?.isBlank)!{
                txtEmail.tag = 102
                txtCountryCode.hide(byWidth: false)
                vwSeprater.isHidden = false
            } else {
                txtEmail.tag = 100
                txtCountryCode.hide(byWidth: true)
                vwSeprater.isHidden = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        txtEmail.hideValidationMessage(50.0)
        self.showValidation(isAdd: false)

        return true
    }
}


//MARK:-
//MARK:- Action

extension ForgotPwdViewController {
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {
        
        if (self.txtEmail.text?.isBlank)! {
            self.txtEmail.tag = 100
          
            self.vwContent.addSubview(self.txtEmail.showValidationMessage(50.0, CBlankEmailOrMobileMessage))
            self.txtEmail.textfiledAddRemoveShadow(true)
            self.showValidation(isAdd: true)
            
        } else if !(self.txtEmail.text?.isBlank)! {
            
            self.txtEmail.tag = 100
            
            //...Email
            if self.txtEmail.text?.range(of:"@") != nil || self.txtEmail.text?.rangeOfCharacter(from: CharacterSet.letters) != nil  {
                
                if !(self.txtEmail.text?.isValidEmail)! {
                    self.vwContent.addSubview(self.txtEmail.showValidationMessage(50.0, CInvalidEmailMessage))
                    self.txtEmail.textfiledAddRemoveShadow(true)
                    self.showValidation(isAdd: true)
                    
                } else {
                    self.forgotPassword(type: CEmailType)
                }
                
            } else {
               
                self.txtEmail.tag = 102
                
                //...Mobile
                if !(self.txtEmail.text?.isValidPhoneNo)! || ((self.txtEmail.text?.count)! > 10 || (self.txtEmail.text?.count)! < 10) {
                    self.vwContent.addSubview(self.txtEmail.showValidationMessage(50.0, CInvalidMobileMessage))
                    self.txtEmail.textfiledAddRemoveShadow(true)
                    self.showValidation(isAdd: true)
                } else {
                    self.forgotPassword(type: CMobileType)
                }
            }
        }
    }
}


//MARK:-
//MARK:- API

extension ForgotPwdViewController {
    
    func forgotPassword(type : Int) {
        self.resignKeyboard()
        
        var dict = [String : AnyObject]()
        
        if type == CMobileType {
            dict = ["type" : type as AnyObject,
                    "userName" : txtEmail.text as AnyObject,
                    CCountryId : countryID as AnyObject,
                    "deviceInfo" : ["platform" : "IOS",
                                    "deviceVersion" : UIDevice.current.systemVersion,
                                    "deviceOS" : UIDevice.current.systemVersion,
                                    "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String]] as [String : AnyObject]

        } else {
            dict = ["type" : type as AnyObject,
                    "userName" : txtEmail.text as AnyObject,
                    "deviceInfo" : ["platform" : "IOS",
                                    "deviceVersion" : UIDevice.current.systemVersion,
                                    "deviceOS" : UIDevice.current.systemVersion,
                                    "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String]] as [String : AnyObject]
        }
        
        APIRequest.shared().forgotPassword(dict: dict) { (response, error) in
            
            if response != nil && error == nil {
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]

                if let resetPwdVC = CStoryboardLRF.instantiateViewController(withIdentifier: "ResetPwdViewController") as? ResetPwdViewController {
                    
                    resetPwdVC.verifyCode = dataResponse.valueForString(key: "verifyCode")
                    
                    if type == CEmailType {
                        resetPwdVC.isEmail = true
                    } else {
                        resetPwdVC.isEmail = false
                        resetPwdVC.countryId = self.countryID
                    }
                    
                    resetPwdVC.strEmailMobile = self.txtEmail.text!
                    self.navigationController?.pushViewController(resetPwdVC, animated: true)
                }
                
            }
        }
    }
}
