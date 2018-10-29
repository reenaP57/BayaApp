//
//  AddRequestDocViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class AddRequestDocViewController: ParentViewController {

    @IBOutlet weak var vwMsg : UIView!
    @IBOutlet weak var txtDocName : UITextField!
    @IBOutlet weak var txtVMsg : UITextView! {
        didSet {
            txtVMsg.placeholderFont = CFontAvenir(size: IS_iPhone ? 14.0 : 18.0, type: .medium).setUpAppropriateFont()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    func initialize() {
        
        self.title = "Request a Document"
        GCDMainThread.async {
            self.vwMsg.layer.masksToBounds = true
            self.vwMsg.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            self.vwMsg.layer.shadowOpacity = 5
            self.vwMsg.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.vwMsg.layer.shadowRadius = 7
            self.vwMsg.layer.cornerRadius = 3
        }
    }
}


//MARK:-
//MARK:- UITextFieldDelegate

extension AddRequestDocViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.txtDocName.hideValidationMessage(15.0)
        return true
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension AddRequestDocViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.txtDocName.hideValidationMessage(15.0)
        textView.hideValidationMessage(70.0)
        self.showValidation(isAdd: false)
        _ = self.vwMsg.setConstraintConstant(70.0, edge: .bottom, ancestor: true)
        
        if textView.text.count > 0 {
            textView.placeholderColor = UIColor.clear
        } else {
            textView.placeholderColor = ColorGray
        }
     }
}


//MARK
//MARk:- Action

extension AddRequestDocViewController {
    
    func showValidation(isAdd : Bool){
        
        //...Set validation for purpose textView
        self.txtVMsg.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
        
        if isAdd {
            //... show validation
            txtVMsg.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            vwMsg.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            vwMsg.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
            vwMsg.layer.borderWidth = 1.0
            vwMsg.layer.borderColor = CRGB(r: 247, g: 51, b: 52).cgColor
        } else {
            //...Hide validation
            txtVMsg.backgroundColor = UIColor.white
            vwMsg.backgroundColor = UIColor.white
            vwMsg.layer.borderWidth = 0.0
            vwMsg.layer.borderColor = UIColor.white.cgColor
            vwMsg.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
        }
    }
    
    @IBAction func btnSubmitClicked(sender : UIButton) {
        
        if (self.txtDocName.text?.isBlank)! {
            
            self.txtVMsg.hideValidationMessage(70.0)
            self.showValidation(isAdd: false)
            _ = self.vwMsg.setConstraintConstant(70.0, edge: .bottom, ancestor: true)
            self.view.addSubview(self.txtDocName.showValidationMessage(15.0,CBlankDocumentName))
        
        } else if (self.txtVMsg.text?.isBlank)! {

            self.txtDocName.hideValidationMessage(15.0)
            GCDMainThread.async {
                self.view.addSubview(self.txtVMsg.showValidationMessage(Gap, CBlankDocMsg,self.vwMsg.CViewX, self.vwMsg.CViewY))
                self.txtVMsg.textfiledAddRemoveShadow(true)
                self.showValidation(isAdd: true)
            }
            _ = self.vwMsg.setConstraintConstant((30/2) + 30 + lblMessage.frame.size.height, edge: .bottom, ancestor: true)
        
        } else {
            self.navigationController?.popViewController(animated: true)
          //  self.showAlertView("Your request sent successfully.", completion: ni)
        }
      
    }
}
