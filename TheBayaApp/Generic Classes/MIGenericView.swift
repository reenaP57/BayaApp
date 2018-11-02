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
            
        } else if self.tag == 103 {
            //...TextField Shadow for Login and Forgot screen
            
            self.layer.cornerRadius = cornerRadius
            self.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
  
        } else if self.tag == 104 {
            
            //...Shadow for project detail, Timeline screen card
            self.shadow(color: UIColor.black, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 3.0, shadowOpacity: 0.5)
            self.layer.cornerRadius = cornerRadius
            
        } else if self.tag == 105 {
            
            //...Shadow and border for Payment schedule screen
            
            self.layer.borderWidth = 2
            self.layer.borderColor = CRGB(r: 185, g: 200, b: 207).cgColor
            self.shadow(color: ColorShadow, shadowOffset: CGSize(width: 7, height: 5), shadowRadius: 5.0, shadowOpacity: 0.7)
            self.layer.cornerRadius = cornerRadius
            
        } else if self.tag == 106 {
            
            //... Border for Payment schedule screen
            
            self.layer.borderWidth = 1
            self.layer.borderColor = CRGB(r: 185, g: 200, b: 207).cgColor
            self.layer.cornerRadius = cornerRadius
            
        } else {
            //...Set only raduis
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
