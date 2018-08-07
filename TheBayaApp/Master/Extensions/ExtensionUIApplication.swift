//
//  ExtensionUIApplication.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 31/08/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension of UIApplication For getting the TopMostViewController(UIViewController) of Application.
extension UIApplication {
    
    /// A Computed Property (only getter) of UIViewController For getting the TopMostViewController(UIViewController) of Application. For using this property you must have instance of UIApplication Like this:(UIApplication.shared).
    var topMostViewController:UIViewController {
        
        var topViewController = self.keyWindow?.rootViewController
        
        while topViewController?.presentedViewController != nil {
            topViewController = topViewController?.presentedViewController
        }
        
        return topViewController!
    }
    
}
