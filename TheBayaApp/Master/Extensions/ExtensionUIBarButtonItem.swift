//
//  ExtensionUIBarButtonItem.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 01/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension of UIBarButtonItem For TouchUpInside Handler.
extension UIBarButtonItem {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        static var genericTouchUpInsideHandler = "genericTouchUpInsideHandler"
    }
    
    /// This method is used for UIBarButtonItem's touchUpInside Handler
    ///
    /// - Parameter genericTouchUpInsideHandler: genericTouchUpInsideHandler will give you object of UIBarButtonItem.
    func touchUpInside(genericTouchUpInsideHandler:genericTouchUpInsideHandler<UIBarButtonItem>) {
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.genericTouchUpInsideHandler, genericTouchUpInsideHandler, .OBJC_ASSOCIATION_RETAIN)
        
        self.action = #selector(handleButtonTouchEvent(sender:))
    }
    
    /// This Private method is used for handle the touch event of UIBarButtonItem.
    ///
    /// - Parameter sender: UIBarButtonItem.
    @objc private func handleButtonTouchEvent(sender:UIBarButtonItem) {
        
        if let genericTouchUpInsideHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.genericTouchUpInsideHandler) as?  genericTouchUpInsideHandler<UIBarButtonItem> {
            
            genericTouchUpInsideHandler(sender)
        }
    }
    
}
