//
//  ExtensionUIResponder.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 31/08/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension of UIResponder For getting the ParentViewController(UIViewController) of any UIView.
extension UIResponder {
    
    /// This Property is used to getting the ParentViewController(UIViewController) of any UIView.
    var viewController:UIViewController? {
        
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            guard self.next != nil else { return nil }
            return self.next?.viewController
        }
    }
    
}
