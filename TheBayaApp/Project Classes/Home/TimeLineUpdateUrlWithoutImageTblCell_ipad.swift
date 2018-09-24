//
//  TimeLineUpdateUrlWithoutImageTblCell_ipad.swift
//  TheBayaApp
//
//  Created by mac-0005 on 24/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineUpdateUrlWithoutImageTblCell_ipad: UITableViewCell {

    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var lblImgTitle : UILabel!
    @IBOutlet weak var lblImgDescription : UILabel!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnLinkContent : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        GCDMainThread.async {
            self.viewContainer.layer.borderWidth = 1
            self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
            self.viewContainer.layer.cornerRadius = 15
        }
    }

}
