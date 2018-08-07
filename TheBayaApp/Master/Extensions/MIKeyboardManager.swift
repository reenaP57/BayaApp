//
//  MIKeyboardManager.swift
//  Swifty_Master
//
//  Created by mind-0002 on 15/11/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

protocol MIKeyboardManagerDelegate : class {
    func keyboardWillShow(notification:Notification , keyboardHeight:CGFloat)
    func keyboardDidHide(notification:Notification)
}

class MIKeyboardManager  {
    
    private init() {}
    
    private static let miKeyboardManager:MIKeyboardManager = {
        let miKeyboardManager = MIKeyboardManager()
        return miKeyboardManager
    }()
    
    static var shared:MIKeyboardManager {
        return miKeyboardManager
    }
    
    weak var delegate:MIKeyboardManagerDelegate?
    
    func enableKeyboardNotification() {
        
        NotificationCenter.default.addObserver(MIKeyboardManager.shared, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(MIKeyboardManager.shared, selector: #selector(self.keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func disableKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(MIKeyboardManager.shared, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(MIKeyboardManager.shared, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc  private func keyboardWillShow(notification:Notification) {
        
        if let info = notification.userInfo {
            
            if let keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                delegate?.keyboardWillShow(notification: notification, keyboardHeight: keyboardRect.height)
            }
        }
    }
    
    @objc private func keyboardDidHide(notification:Notification) {
        delegate?.keyboardDidHide(notification: notification)
    }
    
}
