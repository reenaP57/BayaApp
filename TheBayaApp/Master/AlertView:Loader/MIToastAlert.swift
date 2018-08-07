//
//  MIToastAlert.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 04/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

class MIToastAlert {
    
    private init() {}
    
    private static let miToastAlert:MIToastAlert = {
        let miToastAlert = MIToastAlert()
        return miToastAlert
    }()
    
    static var shared:MIToastAlert {
        return miToastAlert
    }
    
    fileprivate static var animationDuration:TimeInterval = 1.0
    fileprivate static var viewRemovingDuration:TimeInterval = 2.5
    fileprivate static var timer = Timer()
}

extension MIToastAlert {
    
    enum MIToastAlertPosition {
        case top
        case center
        case bottom
    }
}

extension MIToastAlert {
    
    fileprivate static let toastAlertView:UIView = {
        let toastAlertView = UIView()
        toastAlertView.tag = 10000
        toastAlertView.layer.cornerRadius = 3.5
        toastAlertView.backgroundColor = CRGBA(r: 0.0, g: 0.0, b: 0.0, a: 0.0)
        toastAlertView.translatesAutoresizingMaskIntoConstraints = false
        return toastAlertView
    }()
    
    func setToastalertViewBgColor(color:UIColor?) {
        
        if var rgba = color?.getRGB() {
            
            rgba.a = 0.0
            
            MIToastAlert.toastAlertView.backgroundColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
        }
    }
    
    func setToastalertViewAlpha(alpha:CGFloat) {
        
        if var rgba = MIToastAlert.toastAlertView.backgroundColor?.getRGB() {
            
            rgba.a = alpha
            
            MIToastAlert.toastAlertView.backgroundColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
        }
    }
    
    func setToastalertViewCornerRadius(cornerRadius:CGFloat) {
        MIToastAlert.toastAlertView.layer.cornerRadius = cornerRadius
    }
    
}

extension MIToastAlert {
    
    fileprivate static let lblMessage:UILabel = {
        let lblMessage = UILabel()
        lblMessage.textAlignment = .center
        lblMessage.textColor = CRGBA(r: 255.0, g: 255.0, b: 255.0, a: 0.0)
        lblMessage.numberOfLines = 0
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        return lblMessage
    }()
    
    func setLblMessageTextAlignment(alignment:NSTextAlignment) {
        MIToastAlert.lblMessage.textAlignment = alignment
    }
    
    func setLblMessageFont(font:UIFont) {
        MIToastAlert.lblMessage.font = font
    }
    
    func setLblMessageTextColor(textColor:UIColor) {
        MIToastAlert.lblMessage.textColor = textColor
    }
    
    fileprivate func setLblMessageText(message:String) {
        MIToastAlert.lblMessage.text = message
    }
}

extension MIToastAlert {

    func showToastAlert(position:MIToastAlert.MIToastAlertPosition , message:String) {
        
        if let toastAlertView = appDelegate.window.viewWithTag(10000) {
            MIToastAlert.timer.invalidate()
            toastAlertView.removeAllSubviews()
            toastAlertView.removeFromSuperview()
        }
        
        MIToastAlert.shared.setLblMessageText(message: message)
        self.resizeToastalertView(position: position)
        self.performAnimation()
    }
    
    private func resizeToastalertView(position:MIToastAlertPosition) {
        
        appDelegate.window.addSubview(MIToastAlert.toastAlertView)
        
        NSLayoutConstraint(item: MIToastAlert.toastAlertView, attribute: .centerX, relatedBy: .equal, toItem: appDelegate.window, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: MIToastAlert.toastAlertView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CScreenWidth - 10.0 - 10.0).isActive = true
        
        var toastAlertViewAttribute:NSLayoutAttribute
        var constant:CGFloat
        var appWindowAttribute:NSLayoutAttribute
        
        switch position {
            
        case .top:
            constant = (IS_iPhone_X ? 88.0 : 64.0) + 20.0
            toastAlertViewAttribute = .top
            appWindowAttribute = .top
            
        case .center:
            constant = 0.0
            toastAlertViewAttribute = .centerY
            appWindowAttribute = .centerY
            
        case .bottom:
            constant = (IS_iPhone_X ? -(34.0 + 20.0) : -20.0)
            toastAlertViewAttribute = .bottom
            appWindowAttribute = .bottom
            
        }
        
        NSLayoutConstraint(item: MIToastAlert.toastAlertView, attribute: toastAlertViewAttribute, relatedBy: .equal, toItem: appDelegate.window, attribute: appWindowAttribute, multiplier: 1.0, constant: constant).isActive = true
        
        MIToastAlert.toastAlertView.addSubview(MIToastAlert.lblMessage)
        
        NSLayoutConstraint(item: MIToastAlert.lblMessage, attribute: .leading, relatedBy: .equal, toItem: MIToastAlert.toastAlertView, attribute: .leading, multiplier: 1.0, constant: 10.0).isActive = true
        
        NSLayoutConstraint(item: MIToastAlert.lblMessage, attribute: .top, relatedBy: .equal, toItem: MIToastAlert.toastAlertView, attribute: .top, multiplier: 1.0, constant: 10.0).isActive = true
        
        NSLayoutConstraint(item: MIToastAlert.lblMessage, attribute: .trailing, relatedBy: .equal, toItem: MIToastAlert.toastAlertView, attribute: .trailing, multiplier: 1.0, constant: -10.0).isActive = true
        
        NSLayoutConstraint(item: MIToastAlert.lblMessage, attribute: .bottom, relatedBy: .equal, toItem: MIToastAlert.toastAlertView, attribute: .bottom, multiplier: 1.0, constant: -10.0).isActive = true
    }
    
    fileprivate func performAnimation() {
        
        UIView.animate(withDuration: MIToastAlert.animationDuration) {
            
            if var rgba = MIToastAlert.toastAlertView.backgroundColor?.getRGB() {
                
                rgba.a = 1.0
                
                MIToastAlert.toastAlertView.backgroundColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
            }
            
            if var rgba = MIToastAlert.lblMessage.textColor.getRGB() {
                
                rgba.a = 1.0
                
                MIToastAlert.lblMessage.textColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
            }
        }
        
        if #available(iOS 10.0, *) {
            MIToastAlert.timer = Timer.scheduledTimer(withTimeInterval: MIToastAlert.viewRemovingDuration, repeats: false) { (_timer) in
                
                UIView.animate(withDuration: MIToastAlert.animationDuration, animations: {
                    
                    if var rgba = MIToastAlert.toastAlertView.backgroundColor?.getRGB() {
                        
                        rgba.a = 0.0
                        
                        MIToastAlert.toastAlertView.backgroundColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
                    }
                    
                }, completion: { (completion) in
                    
                    if completion {
                        
                        _timer.invalidate()
                        MIToastAlert.toastAlertView.removeAllSubviews()
                        MIToastAlert.toastAlertView.removeFromSuperview()
                    }
                })
            }
        } else {
            // Fallback on earlier versions
            
            UIView.animate(withDuration: MIToastAlert.animationDuration, animations: {
                
                if var rgba = MIToastAlert.toastAlertView.backgroundColor?.getRGB() {
                    
                    rgba.a = 0.0
                    
                    MIToastAlert.toastAlertView.backgroundColor = CRGBA(r: rgba.r * 255.0, g: rgba.g * 255.0, b: rgba.b * 255.0, a: rgba.a)
                }
                
            }, completion: { (completion) in
                
                if completion {
                    MIToastAlert.toastAlertView.removeAllSubviews()
                    MIToastAlert.toastAlertView.removeFromSuperview()
                }
            })
        }
    }
}

