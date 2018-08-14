//
//  SettingTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SettingTblCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgVArrow : UIImageView!
    @IBOutlet weak var switchNotify : UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
