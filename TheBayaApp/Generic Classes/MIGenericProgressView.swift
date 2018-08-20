//
//  MIGenericProgressView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class MIGenericProgressView: UIProgressView {
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupProgressView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // self.setupProgressView()
    }
    
    func setupProgressView() {
      self.progressImage = appDelegate.setProgressGradient(frame: self.bounds)
    }
}
