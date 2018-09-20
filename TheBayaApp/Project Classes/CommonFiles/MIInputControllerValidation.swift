//
//  MIInputControllerValidation.swift
//  TextFiledValidation
//
//  Created by mac-0005 on 03/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import Foundation
import UIKit

var lblMessage = UILabel()

extension UITextField {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self == textField {
            self.hideValidationMessage(15.0)
        }
        return true
    }
    
    func textfiledAddRemoveShadow(_ isAdd : Bool)
    {
        if isAdd{
            self.backgroundColor = UIColor.white
            self.layer.borderWidth = 0.0
            layer.masksToBounds = false
            layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            layer.shadowOpacity = 5
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowRadius = 7
        }else
        {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = CRGB(r: 247, g: 51, b: 52).cgColor
            self.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            
            layer.masksToBounds = false
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOpacity = 0
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 0
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
    
    func hideValidationMessage(_ space : CGFloat)
    {
        if self.tag == lblMessage.tag {
            lblMessage.removeFromSuperview()
            updateTextFiledBottomSpace(space)
           self.textfiledAddRemoveShadow(true)
        }
    }
    
    func showValidationMessage(_ space : CGFloat , _ message : String) -> UILabel
    {
       self.textfiledAddRemoveShadow(false)
       
        
       // self.delegate = self
        
        DispatchQueue.main.async {
            lblMessage.tag = self.tag
            lblMessage.text = message
            
            if self.tag == 102 {
                //...For Auto detect country code
                lblMessage.frame = CGRect(x: IS_iPad ? self.frame.origin.x - 75 + 8 : self.frame.origin.x - 65 + 8, y: self.frame.origin.y + self.frame.size.height + space/2, width: self.frame.size.width - 16, height: 15.0)

            } else {
                lblMessage.frame = CGRect(x: self.frame.origin.x + 8, y: self.frame.origin.y + self.frame.size.height + space/2, width: self.frame.size.width - 16, height: 15.0)
            }
            
            lblMessage.numberOfLines = 0
            lblMessage.textColor = ColorValidation
            
            lblMessage.font = CFontAvenir(size: 14, type: .roman).setUpAppropriateFont()
            lblMessage.sizeToFit()
            self.updateTextFiledBottomSpace((space/2) + space + lblMessage.frame.size.height)
        }
        return lblMessage
    }
}

extension UITextView{
  
    func textfiledAddRemoveShadow(_ isAdd : Bool)
    {
        if isAdd{
            self.backgroundColor = UIColor.white
            self.layer.borderWidth = 0.0
            self.layer.masksToBounds = true
            self.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            self.layer.shadowOpacity = 5
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowRadius = 7
        }else
        {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = CRGB(r: 247, g: 51, b: 52).cgColor
            self.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            
            layer.masksToBounds = true
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOpacity = 0
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 0
        }
        
    }
    
    func updateTextFiledBottomSpace(_ bottomSpace : CGFloat)
    {
        if self.tag == 102 {
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
          return
        }
        
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
    
    func hideValidationMessage(_ space : CGFloat)
    {
        if self.tag == lblMessage.tag {
            lblMessage.removeFromSuperview()
            updateTextFiledBottomSpace(space)
            
            if self.tag != 102{
                self.textfiledAddRemoveShadow(true)
            }
        }
    }
    
    func showValidationMessage(_ space : CGFloat , _ message : String, _ xPoint : CGFloat, _ yPoint : CGFloat) -> UILabel
    {
        self.textfiledAddRemoveShadow(false)
        //self.delegate = self
        
        DispatchQueue.main.async {
            lblMessage.tag = self.tag
            lblMessage.text = message
            lblMessage.frame = CGRect(x: xPoint + 8, y: yPoint + self.frame.size.height + space/2, width: self.frame.size.width - 16, height: 15.0)
            lblMessage.numberOfLines = 0
            lblMessage.textColor = CRGB(r: 247, g: 51, b: 52)
            lblMessage.font = CFontAvenir(size: 14, type: .roman).setUpAppropriateFont()
            lblMessage.sizeToFit()
            self.updateTextFiledBottomSpace((space/2) + space + lblMessage.frame.size.height)
        }
        return lblMessage
    }
}
