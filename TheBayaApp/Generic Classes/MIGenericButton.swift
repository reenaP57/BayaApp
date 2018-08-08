//
//  GenericButton.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MIGenericButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGenericButton()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        
    }
}


// MARK: -
// MARK: - Basic Setup For GenericButton.
extension MIGenericButton {
    
    fileprivate func setupGenericButton() {
        
        ///... Common Setup
        self.titleLabel?.font = self.titleLabel?.font.setUpAppropriateFont()
    }
}
