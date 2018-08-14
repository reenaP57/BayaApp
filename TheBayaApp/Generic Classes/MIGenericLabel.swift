//
//  GenericLabel.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MIGenericLabel: UILabel {

    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGenericLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.tag == 101 {
            self.setGradientBackground()
        }
    }
}


extension MIGenericLabel {
    
    fileprivate func setupGenericLabel() {
        
        ///... Common Setup
        self.font = self.font.setUpAppropriateFont()
        self.text = CLocalize(text: self.text ?? "")
    }
    
    func setGradientBackground() {
        
        gradientLayer.colors = [ColorGradient1Background.cgColor, ColorGradient2Background.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.0)
        self.layer.insertSublayer(gradientLayer, below: self.layer)
    }

}
