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
    @IBOutlet weak var cnVideoViewHeight : NSLayoutConstraint!
    @IBOutlet weak var cnVideoViewWidth : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func updateImageViewSize(){
        cnVideoViewWidth.constant = CScreenHeight*271/1144
        cnVideoViewHeight.constant = CScreenHeight*161/1144
    }

}
