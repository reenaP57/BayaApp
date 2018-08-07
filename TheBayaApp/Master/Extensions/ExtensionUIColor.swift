//
//  ExtensionUIColor.swift
//  Swifty_Master
//
//  Created by mind-0002 on 10/11/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func getRGB() -> (r:CGFloat , g:CGFloat , b:CGFloat , a:CGFloat)? {
        
        var red:CGFloat = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        
        return (red , green , blue , alpha)
    }
    
    func lightColor(byPercentage:CGFloat) -> UIColor? {
        return adjustColor(byPercentage: abs(byPercentage))
    }
    
    func darkColor(byPercentage:CGFloat) -> UIColor? {
        return adjustColor(byPercentage: (-1 * abs(byPercentage)))
    }
    
    private func adjustColor(byPercentage:CGFloat) -> UIColor? {
        
        guard let RGB = self.getRGB() else { return nil }
            
        return UIColor(red: min(RGB.r + byPercentage/100.0, 1.0), green: min(RGB.g + byPercentage/100.0, 1.0), blue: min(RGB.b + byPercentage/100.0, 1.0), alpha: RGB.a)
    }
}
