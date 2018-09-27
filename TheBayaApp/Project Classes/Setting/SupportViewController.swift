//
//  SupportViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SupportViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtVMsg : UITextView!{
        didSet {
            txtVMsg.placeholderFont = CFontAvenir(size: IS_iPhone ? 14.0 : 18.0, type: .medium).setUpAppropriateFont()
        }
    }
    
    @IBOutlet fileprivate weak var imgVUpload : UIImageView!
    @IBOutlet fileprivate weak var vwMsg : UIView!
    
    var imgData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CAppSupportScreenName)
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "App Support"
    }
    
    func showValidation(isAdd : Bool){
        
        self.txtVMsg.backgroundColor = UIColor.white
        self.txtVMsg.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
        
        if isAdd {
            vwMsg.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
            vwMsg.layer.borderWidth = 1.0
            vwMsg.layer.borderColor = CRGB(r: 247, g: 51, b: 52).cgColor
            
        } else {
            vwMsg.layer.borderWidth = 0.0
            vwMsg.layer.borderColor = UIColor.white.cgColor
            vwMsg.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
            
        }
    }
}

//MARK:-
//MARK:- Action

extension SupportViewController {
    
    @IBAction func btnSendClicked (sender : UIButton) {
        
        if (self.txtVMsg.text?.isBlank)! {
        self.view.addSubview(self.txtVMsg.showValidationMessage(15.0,CBlankFeedbackSupport,vwMsg.CViewX, vwMsg.CViewY))

            self.txtVMsg.textfiledAddRemoveShadow(true)
            self.showValidation(isAdd: true)
            _ = self.vwMsg.setConstraintConstant((30/2) + 30 + lblMessage.frame.size.height, edge: .bottom, ancestor: true)
        } else {
            self.postAppSupportDetail()
        }
    }
    
    @IBAction func btnUploadImage (sender : UIButton) {
        
        if IS_iPad {
            
            let actionSheet = UIAlertController(title: "Please Select Camera or Photo Library", message: "", preferredStyle: .alert)
          
            actionSheet.addAction(UIAlertAction(title: "Take A Photo", style: .default, handler: { (UIAlertAction) in
                self.presentImagePickerControllerWithCamera(allowEditing: false) { (image, data) in
                    
                    if let selectedImage = image {
                       self.setUploadedImg(img : selectedImage)
                    }
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Choose From Phone", style: .default, handler: { (UIAlertAction) in
                self.presentImagePickerControllerWithGallery(allowEditing: false) { (image, data) in
                    
                    if let selectedImage = image {
                         self.setUploadedImg(img : selectedImage)
                    }
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
            
            
        } else {
            
            self.presentImagePickerController(allowEditing: true) { (image, info) in
                
                if let selectedImage = image {
                    self.setUploadedImg(img : selectedImage)
                }
            }
        }
    }
    
    func setUploadedImg(img : UIImage) {
        imgVUpload.contentMode = .scaleAspectFit
        imgVUpload.image = img
        self.imgData = UIImageJPEGRepresentation(img, 0.5)!
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension SupportViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.hideValidationMessage(15.0)
        self.showValidation(isAdd: false)
        _ = self.vwMsg.setConstraintConstant(IS_iPad ? 23 : 20, edge: .bottom, ancestor: true)
        
        if textView.text.count > 0 {
            textView.placeholderColor = UIColor.clear
        } else {
            textView.placeholderColor = ColorGray
        }
        
        if textView.text.count > CharacterLimit {
            let currentText = textView.text as NSString
            txtVMsg.text = currentText.substring(to: currentText.length - 1)
        }
    }
}


//MARK:-
//MARK:- API

extension SupportViewController {
    
    func postAppSupportDetail() {
   
        let dict = ["message" : txtVMsg.text as AnyObject,
                    "deviceInfo" : "a",
                    "iPhone" : 1,
                    "platform" : "IOS",
                    "deviceVersion" : UIDevice.current.model,
                    "deviceOS" : UIDevice.current.systemVersion,
                    "appVersion" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String] as [String : AnyObject]
        
        
        APIRequest.shared().support(dict: dict as [String : AnyObject], imgData: imgData) { (response, error) in
            
            if response != nil && error == nil {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CSuccessSupportMessage, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}
