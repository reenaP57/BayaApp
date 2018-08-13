//
//  TimeLineImgCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 13/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineImgCollCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVSlider : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVSlider.layer.cornerRadius = 5
        imgVSlider.layer.masksToBounds = true
    }
}
