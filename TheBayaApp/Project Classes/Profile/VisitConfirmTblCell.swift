//
//  VisitConfirmTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 27/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class VisitConfirmTblCell: UITableViewCell {

    @IBOutlet weak var lblProjectName : UILabel!
    @IBOutlet weak var lblTimeMsg : UILabel!
    @IBOutlet weak var imgVProject : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var btnCall : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgVProject.layer.cornerRadius = 5
        imgVProject.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
