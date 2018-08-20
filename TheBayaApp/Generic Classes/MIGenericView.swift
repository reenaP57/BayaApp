//
//  GenericView.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MIGenericView: UIView {
    
    let gradientLayer = CAGradientLayer()

    @IBInspectable var cornerRadius : CGFloat = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.tag == 101 {
            
            ///... A View that will in CornerRadius shape AND in shadow shape.
            
            self.shadow(color: ColorShadow, shadowOffset: CGSize(width: 5, height: 5), shadowRadius: 5.0, shadowOpacity: 0.5)
            self.layer.cornerRadius = cornerRadius
            
        }  else {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
