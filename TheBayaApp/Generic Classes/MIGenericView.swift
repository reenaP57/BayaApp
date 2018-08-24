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
    @IBInspectable var gradientColor1 : UIColor = ColorWhite
    @IBInspectable var gradientColor2 : UIColor = ColorWhite
    
    
    @IBInspectable var cornerRadius : CGFloat = 0.0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if self.tag == 101 {
            
            ///... A View that will in CornerRadius shape AND in shadow shape.
            
            self.shadow(color: ColorShadow, shadowOffset: CGSize(width: 7, height: 5), shadowRadius: 5.0, shadowOpacity: 0.7)
            self.layer.cornerRadius = cornerRadius
            
        } else if self.tag == 102 {
            
            ///... Set gradient
            self.setGradientBackground()
            
        }  else {
            self.layer.cornerRadius = cornerRadius
        }
    }

    
    func setGradientBackground() {
        
        gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.0)
        self.layer.insertSublayer(gradientLayer, below: self.layer)
        
    }
    
}
