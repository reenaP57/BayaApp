//
//  TimeLineUpdateUrlTblCell_ipad.swift
//  TheBayaApp
//
//  Created by mac-00017 on 22/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineUpdateUrlTblCell_ipad: UITableViewCell {

    @IBOutlet weak var imgVUpdate : UIImageView!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVUpdate.layer.cornerRadius = 5
        imgVUpdate.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
