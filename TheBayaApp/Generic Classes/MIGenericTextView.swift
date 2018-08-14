//
//  GenericTextView.swift
//  TAP
//
//  Created by mac-00017 on 14/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MIGenericTextView : UITextView {
    
    override func awakeFromNib() {
        self.setupGenericTextView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.masksToBounds = false
        layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
        layer.shadowOpacity = 5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 7
    }
}


// MARK: -
// MARK: - Basic Setup For GenericTextView.
extension MIGenericTextView {
    
    fileprivate func setupGenericTextView() {
        self.font = self.font?.setUpAppropriateFont()
        self.placeholder = CLocalize(text: self.placeholder!)
    }
    
}
