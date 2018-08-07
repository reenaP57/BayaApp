//
//  ExtensionInt.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 01/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation

// MARK: - Extension of Int For Converting it TO String.
extension Int {
    
    /// A Computed Property (only getter) of String For getting the String value from Int.
    var toString:String {
        return "\(self)"
    }
    
    var toDouble:Double {
        return Double(self)
    }
    
    var toFloat:Float {
        return Float(self)
    }
    
}
