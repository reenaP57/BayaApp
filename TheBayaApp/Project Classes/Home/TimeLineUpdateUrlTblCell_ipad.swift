//
//  TimeLineUpdateUrlTblCell_ipad.swift
//  TheBayaApp
//
//  Created by mac-00017 on 22/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimeLineUpdateUrlTblCell_ipad: UITableViewCell {

    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var lblImgTitle : UILabel!
    @IBOutlet weak var lblImgDescription : UILabel!
    @IBOutlet weak var imgVUpdate : UIImageView!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnZoomImg : UIButton!
    @IBOutlet weak var btnLinkContent : UIButton!
    @IBOutlet weak var cnImgVUpdateHeight : NSLayoutConstraint!
    @IBOutlet weak var cnImgVUpdateWidth : NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgVUpdate.layer.cornerRadius = 5
        imgVUpdate.layer.masksToBounds = true
        
        GCDMainThread.async {
//            self.viewContainer.layer.borderWidth = 1
//            self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
            self.viewContainer.layer.cornerRadius = 7
        }
    }


    func updateImageViewSize(){
        cnImgVUpdateWidth.constant = CScreenHeight*271/1144
        cnImgVUpdateHeight.constant = CScreenHeight*161/1144
    }
}
