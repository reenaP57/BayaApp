//
//  SpecificationTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SpecificationTblCell: UITableViewCell {

    @IBOutlet weak var vwDot : UIView!
    @IBOutlet weak var lblTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        vwDot.layer.cornerRadius = vwDot.CViewHeight/2
        vwDot.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
