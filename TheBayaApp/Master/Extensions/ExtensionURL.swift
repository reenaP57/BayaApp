//
//  ExtensionURL.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 02/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation

// MARK: - Extension of URL For Converting it TO String.
extension URL {
    
    /// A Computed Property (only getter) of URL For getting the String value from URL.
    /// This Computed Property (only getter) returns String? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("String!") then application will crash.
    var toString:String? {
        return self.absoluteString
    }
}
