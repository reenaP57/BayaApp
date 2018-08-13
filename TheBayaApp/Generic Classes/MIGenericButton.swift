//
//  GenericButton.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MIGenericButton: UIButton {

    let gradientLayer = CAGradientLayer()
    
    @IBInspectable var cornerRadius : CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGenericButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        
        if self.tag == 101 {
            self.setGradientBackground()
        }
    }
}


// MARK: -
// MARK: - Basic Setup For GenericButton.

extension MIGenericButton {
    
    fileprivate func setupGenericButton() {
        ///... Common Setup
        self.titleLabel?.font = self.titleLabel?.font.setUpAppropriateFont()
    }
    
    func setGradientBackground() {
        
        gradientLayer.colors = [ColorGradient1Background.cgColor, ColorGradient2Background.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.0)
        self.layer.insertSublayer(gradientLayer, below: self.titleLabel?.layer)
        
    }
}
