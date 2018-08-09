//
//  GenericTextField.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MIGenericTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.font = self.font?.setUpAppropriateFont()
        self.placeholderColor = ColorGray
        self.borderStyle = .none
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.white
        
        self.addLeftImageAsLeftView(strImgName: nil, leftPadding: 15.0)
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
