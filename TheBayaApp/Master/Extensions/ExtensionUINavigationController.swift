//
//  ExtensionUINavigationController.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 30/08/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension of UINavigationController For assigning the RootViewController of UINavigationController.
extension UINavigationController {
    
    /// This static method is used For assigning the RootViewController of UINavigationController.
    ///
    /// - Parameter viewController: Pass the UIViewController's instance for set it as RootViewController of UINavigationController.
    /// - Returns: RootViewController of UINavigationController.
    static func rootViewController(viewController:UIViewController) -> UINavigationController {
        
        return self.init(rootViewController: viewController)
    }
    
    /// This method is used to getting back to any UIViewController among UIViewController's Stack.
    ///
    /// - Parameters:
    ///   - viewController: Pass the UIViewController's instance for which you want to get back.
    ///   - animated: A Bool Value for Animated OR Not.
    func pop_To_ViewController(viewController:UIViewController , animated:Bool) {
        
        for vc in self.viewControllers {
            
            if vc.isKind(of: viewController.classForCoder) {
                self.popToViewController(vc, animated: animated)
            }
        }
    }
    
}
