//
//  MIGenericTextFiled.swift
//  SocialMedia
//
//  Created by mac-0005 on 07/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MIGenericTextFiled: UITextField {
    
    @IBInspectable var placeHolder: String?
    @IBInspectable var placeHolderFont: UIFont?
    
    var lblPlaceHolder = UILabel()
    var viewBottomLine = UIView()
    var btnClearText = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.borderStyle = .none
        self.delegate = self
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        GCDMainThread.async {
            self.placeHolderSetup()
            self.bottomLineViewSetup()
            self.clearTextButtonSetup()
        }
        
    }
    
    
    // MARK:- --------PlaceHolder
    func placeHolderSetup(){
        lblPlaceHolder.frame = CGRect(x: 0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        lblPlaceHolder.text = placeHolder
        lblPlaceHolder.tag = 1002
        lblPlaceHolder.font = CFontPoppins(size: 14, type: .light)
        lblPlaceHolder.isUserInteractionEnabled = false
        self.addSubview(lblPlaceHolder)
    }
    
    func updatePlaceholderFrame(_ isMoveUp : Bool?){
        if isMoveUp!{
            UIView.animate(withDuration: 0.3) {
                self.lblPlaceHolder.frame = CGRect(x: 0.0, y: -10.0, width: self.frame.size.width, height: 20)
                self.lblPlaceHolder.font = CFontPoppins(size: 10, type: .light)
                self.layoutIfNeeded()
            }
        }
        else
        {
            UIView.animate(withDuration: 0.3) {
                self.lblPlaceHolder.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
                self.lblPlaceHolder.font = CFontPoppins(size: 14, type: .light)
                self.layoutIfNeeded()
            }
        }
    }

    // MARK:- --------Bottom Line
    func bottomLineViewSetup(){
        viewBottomLine.frame = CGRect(x: 0.0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1.0)
        viewBottomLine.backgroundColor = CRGB(r: 67, g: 70, b: 67)
        viewBottomLine.tag = 1001
        self.addSubview(viewBottomLine)
    }
    
    // MARK:- --------Cleate Text button
    func clearTextButtonSetup(){
        btnClearText.frame = CGRect(x: 0.0, y: 0, width: 30, height: self.frame.size.height)
        btnClearText.isHidden = true
        btnClearText.setTitle("X", for: .normal)
        btnClearText.setTitleColor(CRGB(r: 131, g: 147, b: 98), for: .normal)
        self.rightViewMode = .always
        self.rightView = btnClearText
        
        btnClearText.touchUpInside { (sender) in
            self.text = ""
            btnClearText.isHidden = true
            updatePlaceholderFrame(false)
            self.resignFirstResponder()
        }
    }
    
    func showHideClearTextButton()
    {
        btnClearText.isHidden = (self.text?.count)! == 0
    }
    
    
    // MARK:- --------Textfiled Delegate methods
    
    @objc func textFieldDidChange(_ textField : UITextField){
        // Hide show clear button
        self.showHideClearTextButton()
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField)
     {
        // update placeholder frame
        self.updatePlaceholderFrame(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.text?.count == 0{
            // update placeholder frame
            self.updatePlaceholderFrame(false)
        }
        
    }

}

/*
var lblMessage = UILabel()
let validationColor = CRGB(r: 247, g: 51, b: 52)

extension UITextField{
    
    func hideValidationMessage(_ space : CGFloat)
    {
        lblMessage.removeFromSuperview()
        updateTextFiledBottomSpace(space)
        self.udpateBottonLineColor(true)
    }
    
    func showValidationMessage(_ space : CGFloat , _ message : String) -> UILabel
    {
        GCDMainThread.async {
//            self.backgroundColor = UIColor.green
            lblMessage.text = message
            lblMessage.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height + space/2, width: self.frame.size.width - 16, height: 15.0)
            lblMessage.numberOfLines = 0
            lblMessage.textColor = validationColor
            lblMessage.backgroundColor = UIColor.red
            
            lblMessage.font = UIFont(name: "Helvetica", size: 10)
            lblMessage.sizeToFit()
            self.updateTextFiledBottomSpace((space/2) + space + lblMessage.frame.size.height)
            self.udpateBottonLineColor(false)
        }
        
        return lblMessage
    }
    
    func udpateBottonLineColor(_ isValidate : Bool){
        for lineInfo in self.subviews{
            if lineInfo.isKind(of: UIView.classForCoder()) && lineInfo.tag == 1001
            {
                lineInfo.backgroundColor = isValidate ? CRGB(r: 67, g: 70, b: 67) : validationColor
            }
            
            if lineInfo.isKind(of: UILabel.classForCoder()) && lineInfo.tag == 1002
            {
//                let lblPlace = lineInfo as? UILabel
//                lblPlace?.textColor = isValidate ? UIColor.black : validationColor
            }
            
            
        }
    }
    
    func updateTextFiledBottomSpace(_ bottomSpace : CGFloat)
    {
        let arrConstraints = self.superview?.constraints as NSArray?
        
        if ((arrConstraints?.count)! > 0)
        {
            arrConstraints?.enumerateObjects({ (constraint, idx, stop) in
                let constraint = constraint as! NSLayoutConstraint
                if ((constraint.firstItem as? NSObject == self && constraint.firstAttribute == .bottom) ||
                    (constraint.secondItem as? NSObject == self && constraint.secondAttribute == .bottom))
                {
                    constraint.constant = bottomSpace
                }
            })
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
}

*/


