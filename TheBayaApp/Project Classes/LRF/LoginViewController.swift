//
//  LoginViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit


class LoginViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtEmail : UITextField!{
        didSet{
            txtEmail.addLeftImageAsLeftView(strImgName: nil, leftPadding: 15.0)
            txtEmail.placeholderColor = ColorGray
        }
    }
    @IBOutlet fileprivate weak var txtPassword : UITextField!
    @IBOutlet fileprivate weak var txtCountryCode : UITextField!{
        didSet{
            txtCountryCode.addLeftImageAsLeftView(strImgName: nil, leftPadding: 7.0)
            txtCountryCode.placeholderColor = ColorGray
        }
    }
    @IBOutlet fileprivate weak var btnRememberMe : UIButton!
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var vwEmail : UIView!
    @IBOutlet fileprivate weak var vwSeprater : UIView!
    @IBOutlet fileprivate weak var lblSignUp : UILabel!

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
        appDelegate.trackScreenNameForGoogleAnalytics(screenName: CLoginScreenName)
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        txtEmail.font = txtEmail.font?.setUpAppropriateFont()
        txtCountryCode.font = txtCountryCode.font?.setUpAppropriateFont()

        txtEmail.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        txtCountryCode.hide(byWidth: true)
        vwSeprater.isHidden = true
        
        self.showValidation(isAdd: false)
        self.setCountryList()
        self.setAtttibuteString()
    }
    
    func setCountryList(){
        
        let arrCountry = TblCountryList.fetch(predicate: nil, orderBy: "country_name", ascending: true)
        let arrCountryCode = arrCountry?.value(forKeyPath: "country_with_code") as? [Any]
        
        if (arrCountryCode?.count)! > 0 {
            
            txtCountryCode.setPickerData(arrPickerData: arrCountryCode!, selectedPickerDataHandler: { (select, index, component) in
                
                let dict = arrCountry![index] as AnyObject
                countryID = dict.value(forKey: "country_id") as! Int
                txtCountryCode.text = "+\(dict.value(forKey: "country_code") ?? "")"
            }, defaultPlaceholder: "+91")
        }
    }
    
    func setAtttibuteString() {
        
        let attributedString = NSMutableAttributedString(string: "New user? Sign Up")
        attributedString.addAttributes([
            .font: CFontAvenir(size:IS_iPhone ? 13.0 : 18.0, type: .heavy).setUpAppropriateFont()!,
            .foregroundColor: ColorGreenSelected
            ], range: NSRange(location: 10, length: 7))
        
        lblSignUp.attributedText = attributedString
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
}


// MARK:- -------- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        if textField == txtEmail {
            
            txtEmail.hideValidationMessage(15.0)
            self.showValidation(isAdd: false)
            
            if (txtEmail.text?.isValidPhoneNo)! && !(txtEmail.text?.isBlank)! {
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
        
        switch textField {
        case txtEmail:
            txtEmail.hideValidationMessage(15.0)
            self.showValidation(isAdd: false)

        default:
            txtPassword.hideValidationMessage(15.0)
            let cs = NSCharacterSet(charactersIn: PASSWORDALLOWCHAR).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }

        return true
    }
}


//MARK:-
//MARK:- Action

extension LoginViewController {
    
    @IBAction fileprivate func btnLoginClicked (sender : UIButton) {
        
            if (self.txtEmail.text?.isBlank)! {
                self.txtEmail.tag = 100
                self.txtPassword.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CBlankEmailOrMobileMessage))
                self.txtEmail.textfiledAddRemoveShadow(true)
                self.showValidation(isAdd: true)
                
            } else if !(self.txtEmail.text?.isBlank)! {
                
                //...Email
                if self.txtEmail.text?.range(of:"@") != nil || self.txtEmail.text?.rangeOfCharacter(from: CharacterSet.letters) != nil  {
                    
                    self.txtEmail.tag = 100
                    
                    if !(self.txtEmail.text?.isValidEmail)! {
                        self.txtPassword.hideValidationMessage(15.0)
                    self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidEmailMessage))
                        self.txtEmail.textfiledAddRemoveShadow(true)
                        self.showValidation(isAdd: true)
                        
                    } else if (self.txtPassword.text?.isBlank)! {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,CBlankPasswordMessage))
                        
                    } else if !(self.txtPassword.text?.isValidPassword)! || (self.txtPassword.text?.count)! < 6 {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0, CInvalidPasswordMessage))
                    }
                    else {
                        self.login(type: CEmailType)
                    }
                    
                } else {
                    //...Mobile Number
                    
                    self.txtEmail.tag = 102
                    
                    if !(self.txtEmail.text?.isValidPhoneNo)! || ((self.txtEmail.text?.count)! > 10 || (self.txtEmail.text?.count)! < 10) {
                        self.txtPassword.hideValidationMessage(15.0)
                    self.vwContent.addSubview(self.txtEmail.showValidationMessage(15.0, CInvalidMobileMessage))
                        self.txtEmail.textfiledAddRemoveShadow(true)
                        self.showValidation(isAdd: true)
                        
                    } else if (self.txtPassword.text?.isBlank)! {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0,CBlankPasswordMessage))
                        
                    } else if !(self.txtPassword.text?.isValidPassword)! || (self.txtPassword.text?.count)! < 6  {
                        self.vwContent.addSubview(self.txtPassword.showValidationMessage(15.0, CInvalidPasswordMessage))
                    } else {
                       self.login(type: CMobileType)
                    }
                }
        }
    }
    
    @IBAction fileprivate func btnForgotPasswordClicked (sender : UIButton) {
        
        if let forgotPwdVC = CStoryboardLRF.instantiateViewController(withIdentifier: "ForgotPwdViewController") as? ForgotPwdViewController {
            self.navigationController?.pushViewController(forgotPwdVC, animated: true)
        }
    }

    @IBAction fileprivate func btnSignUpClicked (sender : UIButton) {
        
        if let signupVC = CStoryboardLRF.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
    }
    
    @IBAction fileprivate func btnRememberMeClicked (sender : UIButton) {
        btnRememberMe.isSelected = !btnRememberMe.isSelected
    }

}


//MARK:-
//MARK:- API

extension LoginViewController {
    
    func login(type : Int) {
        
        self.resignKeyboard()
        
        APIRequest.shared().loginUser(txtEmail.text, txtPassword.text, type, countryID) { (response, error) in
            
            if response != nil && error == nil {
                
                print("Response : ",response as Any)
                
                let dataResponse = response?.value(forKey: CJsonData) as! [String : AnyObject]
                let metaData = response?.value(forKey: CJsonMeta) as! [String : AnyObject]
                let message  = metaData.valueForString(key: CJsonMessage)
                let status = metaData.valueForInt(key: CJsonStatus)
                
                if status == CStatusFour {
                    
                    self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: message, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                        
                        if let verifyVC = CStoryboardLRF.instantiateViewController(withIdentifier: "VerificationViewController") as? VerificationViewController {
                            
                            if dataResponse.valueForInt(key: "emailVerify") == 0 {
                                verifyVC.isEmailVerify = true
                            }
                            
                            verifyVC.verifiyCode = dataResponse.valueForString(key: "verifyCode")
                            self.navigationController?.pushViewController(verifyVC, animated: true)
                        }
                    })
                    
                } else if status == CStatusTen {
                    //...Register From Admin
                    
                    if let changePwdVC = CStoryboardSetting.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController {
                        changePwdVC.isFromLogin = true
                        changePwdVC.isRememberMe =  self.btnRememberMe.isSelected
                        self.navigationController?.pushViewController(changePwdVC, animated: true)
                    }
                    
                } else {
                    if self.btnRememberMe.isSelected && (appDelegate.loginUser?.mobileVerify)! && (appDelegate.loginUser?.emailVerify)! {
                         CUserDefaults.set(true, forKey: UserDefaultRememberMe)
                    }
                    
                   appDelegate.initHomeViewController()
                }
            }
        }
    }
    
}
