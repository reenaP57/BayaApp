//
//  GenericLabel.swift
//  TAP
//
//  Created by mac-00017 on 08/06/18.
//  Copyright © 2018 mac-00017. All rights reserved.
//

import UIKit

class MIGenericLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupGenericLabel()
    }
        
    fileprivate func setupGenericLabel() {
        
        ///... Common Setup
        self.font = self.font.setUpAppropriateFont()
        self.text = CLocalize(text: self.text ?? "")
    }
  

}
