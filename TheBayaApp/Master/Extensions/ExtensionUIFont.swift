//
//  ExtensionUIFont.swift
//  Nerd
//
//  Created by mind-0002 on 12/04/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    func setUpAppropriateFont() -> UIFont? {
        
        if IS_iPhone_5 {
            return UIFont(name: self.fontName, size: self.pointSize - 2.0)
        
        } else if IS_iPhone_6_Plus {
            return UIFont(name: self.fontName, size: self.pointSize + 2.0)
       
        } else if IS_iPad {
            return UIFont(name: self.fontName, size: self.pointSize + 5.0)
        
        } else {
            return UIFont(name: self.fontName, size: self.pointSize)
        }
    }
}
