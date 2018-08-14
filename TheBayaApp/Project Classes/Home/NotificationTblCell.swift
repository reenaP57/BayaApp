//
//  NotificationTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class NotificationTblCell: UITableViewCell {

    @IBOutlet weak var lblProjectName : UILabel!
    @IBOutlet weak var lblMsg : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var imgVProject : UIImageView!
    @IBOutlet weak var btnRateVisit : UIButton!
    @IBOutlet weak var vwContent : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
 
        imgVProject.layer.cornerRadius = 5.0
        imgVProject.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
