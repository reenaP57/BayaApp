//
//  ExtensionUIImageView.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 06/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadGif(name: String) {
        
        DispatchQueue.global().async {
            
            if let image = UIImage.gif(name: name) {
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
}
