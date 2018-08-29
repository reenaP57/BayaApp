//
//  TimelineUpdateVideoTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 27/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimelineUpdateVideoTblCell: UITableViewCell {

    @IBOutlet weak var vwVideoPlayer : UIView!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnPlay : UIButton!
    @IBOutlet weak var imgVThumbNail : UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
