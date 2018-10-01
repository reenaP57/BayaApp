//
//  MIGenericProgressView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MIGenericProgressView: UIProgressView {
    
    var gradientLayer = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupProgressView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupProgressView()
    }
    
    func setupProgressView() {
        
        if gradientLayer.superlayer == nil {
            gradientLayer.colors = [ColorProgressGradient1.cgColor,ColorProgressGradient2.cgColor]
            gradientLayer.frame = frame
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.9, y: 0.0)
            
            UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0.0)
            gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.progressImage = image
        }

        
//        return image!
//
//      self.progressImage = appDelegate.setProgressGradient(frame: self.bounds)
    }
}
