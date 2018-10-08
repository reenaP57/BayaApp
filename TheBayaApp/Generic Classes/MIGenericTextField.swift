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
        
        if self.tag == 101 {
            self.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
    }
}
