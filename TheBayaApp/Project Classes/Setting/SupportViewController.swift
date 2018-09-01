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

    @IBOutlet fileprivate weak var vwMsg : UIView! {
        didSet {
            vwMsg.layer.masksToBounds = true
            vwMsg.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            vwMsg.layer.shadowOpacity = 5
            vwMsg.layer.shadowOffset = CGSize(width: 0, height: 3)
            vwMsg.layer.shadowRadius = 7
            vwMsg.layer.cornerRadius = 3
        }
    }
    
    var imgData = Data()
    
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
        self.title = "App Support"
    }
}

//MARK:-
//MARK:- Action

extension SupportViewController {
    
    @IBAction func btnSendClicked (sender : UIButton) {
        
//        for objView in self.view.subviews{
//            if  objView.isKind(of: UITextView.classForCoder()){
//                let txView = objView as? UITextView
//                txView?.hideValidationMessage(15.0)
//                txView?.resignFirstResponder()
//            }
//        }
//
//        self.view.layoutIfNeeded()
//
//        DispatchQueue.main.async {

            if (self.txtVMsg.text?.isBlank)! {
                self.view.addSubview(self.txtVMsg.showValidationMessage(15.0,CBlankFeedbackSupport))
            } else {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CSuccessSupportMessage, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
       // }
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
        imgVUpload.contentMode = .scaleToFill
        imgVUpload.image = img
        self.imgData = UIImageJPEGRepresentation(img, 0.5)!
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension SupportViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.hideValidationMessage(15.0)
        
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
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        if text == "\n" {
//            return false
//        }
//
//        return true
//    }
}
