//
//  AutoLayout.swift
//  DemoSwift
//
//  Created by mac-0007 on 28/09/16.
//  Copyright © 2016 Jignesh-0007. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



var kAspectRatioConstraint: UInt8 = 0
var kConflictedConstraints: UInt8 = 0

extension UIView
{
    
    //MARK:-
    //MARK:- Public
    
    func hide(byHeight hidden:Bool) -> Void {
        self.view(hide: hidden, attribute: .height)
    }
    
    func hide(byWidth hidden:Bool) -> Void {
        self.view(hide: hidden, attribute: .width)
    }
    
    func setConstraintConstant(_ constant:CGFloat, edge:NSLayoutAttribute, ancestor:Bool) -> Bool {
//        guard (toEdge != .Left && toEdge != .Right && toEdge != .Top && toEdge != .Bottom && toEdge != .Leading && toEdge != .Trailing) else {
//            return
//        }
        
        var success = false
        
        let arrConstraints = (ancestor ? (self.superview?.constraints)! : self.constraints) as NSArray
        
        if (arrConstraints.count > 0)
        {
            arrConstraints.enumerateObjects({ (constraint, idx, stop) in
                let constraint = constraint as! NSLayoutConstraint
                if ((constraint.firstItem as? NSObject == self && constraint.firstAttribute == edge) ||
                    (constraint.secondItem as? NSObject == self && constraint.secondAttribute == edge))
                {
                    constraint.constant = constant
                    success = true
                }
            })
            
            self.superview?.updateLayout()
        }
        
        return success
    }
    
    
    //MARK:-
    //MARK:- Private
    
    fileprivate func view(hide hidden:Bool, attribute:NSLayoutAttribute) -> Void
    {
        if (self.isHidden != hidden)
        {
            let constraint = self.constraint(forAttribute: attribute)
            
            if (hidden)
            {
                self.saveAndRemoveConflictedConstraints(forAttribute: attribute)
                
                if (constraint != nil)
                {
                    self.alpha = (constraint?.constant)!
                    constraint?.constant = 0
                }
                else
                {
                    self.alpha = attribute == .height ? self.size().height : self.size().width
                    self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0))
                }
                
                self.isHidden = true
            }
            else
            {
                self.setConstant(constraint, constant: self.alpha, attribute: attribute)
                self.resetSavedConflictedConstraints(forAttribute: attribute, constraint: constraint)
                self.alpha = 1
                self.isHidden = false
            }
        }
    }
    
    fileprivate func setConstant(_ constraint:NSLayoutConstraint?, constant:CGFloat, attribute:NSLayoutAttribute)
    {
        if (constraint != nil) {
            constraint?.constant = constant
        } else {
            self.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant))
        }
    }
    
    fileprivate func constraint(forAttribute attribute:NSLayoutAttribute) -> NSLayoutConstraint?
    {
        var constraint:NSLayoutConstraint?
        
        (self.constraints as NSArray).enumerateObjects({ (cn, idx, stop) in
            let cn = cn as! NSLayoutConstraint
            if (cn.firstAttribute == attribute &&
                cn.firstItem as? NSObject == self &&
                cn.secondAttribute == .notAnAttribute &&
                cn.secondItem == nil &&
                !cn.isKind(of: NSClassFromString("NSContentSizeLayoutConstraint")!))
            {
                constraint = cn
                stop.pointee = true
            }
        })
        
        return constraint
    }
    
    fileprivate func aspectRatioConstraint() -> NSLayoutConstraint?
    {
        var constraint:NSLayoutConstraint?
        
        (self.constraints as NSArray).enumerateObjects({ (cn, idx, stop) in
            let cn = cn as! NSLayoutConstraint
            if (cn.firstAttribute != cn.secondAttribute &&
                cn.firstItem as? NSObject == self &&
                cn.secondItem as? NSObject == self)
            {
                constraint = cn
                stop.pointee = true
            }
        })
        
        return constraint
    }
    
    fileprivate func saveAndRemoveConflictedConstraints(forAttribute attribute:NSLayoutAttribute) -> Void
    {
        // Store consraint with bottom if self will be hide for height ORRR..
        // Store consraint with right/trailing if self will be hide for width
        
        var arrConstraint:NSArray?
        
        if (attribute == .height)
        {
            arrConstraint = (self.constraints as NSArray).filtered(using: NSPredicate(format: "firstAttribute == %@ && secondAttribute == %@", NSNumber(value: NSLayoutAttribute.bottom.rawValue as Int), NSNumber(value: NSLayoutAttribute.bottom.rawValue as Int))) as NSArray
        }
        else
        {
            arrConstraint = (self.constraints as NSArray).filtered(using: NSPredicate(format: "(firstAttribute == %@ || firstAttribute == %@) && (secondAttribute == %@ || secondAttribute == %@)", NSNumber(value: NSLayoutAttribute.right.rawValue as Int), NSNumber(value: NSLayoutAttribute.trailing.rawValue as Int), NSNumber(value: NSLayoutAttribute.right.rawValue as Int), NSNumber(value: NSLayoutAttribute.trailing.rawValue as Int))) as NSArray
        }
        
        
        if (arrConstraint != nil && arrConstraint?.count > 0)
        {
            self.set(object: arrConstraint, forKey: &kConflictedConstraints)
            
            if (IS_iOS8) {
                NSLayoutConstraint.deactivate(arrConstraint as! [NSLayoutConstraint])
            } else {
                self.removeConstraints(arrConstraint as! [NSLayoutConstraint])
            }
        }
        
        // Check Aspect Ratio Constraint
        let aspecRatio = self.aspectRatioConstraint()
        
        if (aspecRatio != nil) {
            self.set(object: aspecRatio, forKey: &kAspectRatioConstraint)
            
            if (IS_iOS8) {
                aspecRatio?.isActive = false
            } else {
                self.removeConstraint(aspecRatio!)
            }
        }
        
    }
    
    fileprivate func resetSavedConflictedConstraints(forAttribute attribute:NSLayoutAttribute, constraint:NSLayoutConstraint?) -> Void
    {
        let arrConstraints = self.object(forKey: &kConflictedConstraints) as? [NSLayoutConstraint]
        let cAspectRatio = self.object(forKey: &kAspectRatioConstraint) as? NSLayoutConstraint
        
        if (arrConstraints != nil && arrConstraints!.count > 0)
        {
            if (IS_iOS8) {
                NSLayoutConstraint.activate(arrConstraints!)
            } else {
                self.addConstraints(arrConstraints!)
            }
        }
        
        if (cAspectRatio != nil)
        {
            if (constraint != nil) {
                if (IS_iOS8) {
                    constraint?.isActive = false
                } else {
                    self.removeConstraint(constraint!)
                }
            }
            
            if (IS_iOS8) {
                cAspectRatio?.isActive = true
            } else {
                self.addConstraint(cAspectRatio!)
            }
            
            self.set(object: nil, forKey: &kAspectRatioConstraint)
        }
        else
        {
            let size = self.systemLayoutFittingSize()
            let constant = (attribute == .height) ? size.height : size.width
            self.setConstant(constraint, constant: constant, attribute: attribute)
        }
    }
    
    
    
    
    //MARK:-
    //MARK:- Update Layout
    
    fileprivate func size() -> CGSize {
        self.updateLayout()
        return CGSize(width: self.CViewWidth, height: self.CViewHeight)
    }
    
    func updateLayout() -> Void {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func systemLayoutFittingSize() -> CGSize {
        self.updateLayout()
        return self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
}
