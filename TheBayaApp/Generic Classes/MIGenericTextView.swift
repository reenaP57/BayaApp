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
