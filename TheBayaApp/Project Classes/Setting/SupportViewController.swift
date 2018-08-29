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
            txtVMsg.placeholderFont = CFontAvenir(size: 14.0, type: .medium).setUpAppropriateFont()
        }
    }
    
    @IBOutlet fileprivate weak var imgVUpload : UIImageView!

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
        self.title = "Support"
        txtVMsg.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
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
        
        self.presentImagePickerController(allowEditing: true) { (image, info) in
            
            if let selectedImage = image {
                imgVUpload.contentMode = .scaleToFill
                imgVUpload.image = selectedImage
                self.imgData = UIImageJPEGRepresentation(selectedImage, 0.5)!
            }
        }
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            return false
        }
        
        return true
    }
}
