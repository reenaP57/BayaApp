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

extension UITextField  {
    
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
        lblMessage.removeFromSuperview()
        updateTextFiledBottomSpace(space)
        self.textfiledAddRemoveShadow(true)
    }
    
    func showValidationMessage(_ space : CGFloat , _ message : String) -> UILabel
    {
        self.textfiledAddRemoveShadow(false)
        
        DispatchQueue.main.async {
            lblMessage.text = message
            lblMessage.frame = CGRect(x: self.frame.origin.x + 8, y: self.frame.origin.y + self.frame.size.height + space/2, width: self.frame.size.width - 16, height: 15.0)
            lblMessage.numberOfLines = 0
            lblMessage.textColor = ColorValidation
            
            lblMessage.font = CFontAvenirLTStd(size: 14, type: .roman)
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
        lblMessage.removeFromSuperview()
        updateTextFiledBottomSpace(space)
        self.textfiledAddRemoveShadow(true)
    }
    
    func showValidationMessage(_ space : CGFloat , _ message : String) -> UILabel
    {
        self.textfiledAddRemoveShadow(false)
        
        DispatchQueue.main.async {
            lblMessage.text = message
            lblMessage.frame = CGRect(x: self.frame.origin.x + 8, y: self.frame.origin.y + self.frame.size.height + space/2, width: self.frame.size.width - 16, height: 15.0)
            lblMessage.numberOfLines = 0
            lblMessage.textColor = CRGB(r: 247, g: 51, b: 52)
            lblMessage.font = CFontAvenirLTStd(size: 14, type: .roman)
            lblMessage.sizeToFit()
            self.updateTextFiledBottomSpace((space/2) + space + lblMessage.frame.size.height)
        }
        return lblMessage
    }
}
