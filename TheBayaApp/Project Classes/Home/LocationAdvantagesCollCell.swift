//
//  LocationAdvantagesCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class LocationAdvantagesCollCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVLocation : UIImageView!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var lblLocAdvantages : UILabel!

    var arrLocDesc = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
