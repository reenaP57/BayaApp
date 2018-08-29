//
//  TimelineGuideLineView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimelineGuideLineView: UIView {

    @IBOutlet weak var lblGuideLine : UILabel!
    @IBOutlet weak var imgVCheckMark : UIImageView!
    @IBOutlet weak var imgVArrow : UIImageView!
    @IBOutlet weak var btnGotIt : UIButton!
    @IBOutlet weak var cnstImgvCheckmarkY : NSLayoutConstraint!
    @IBOutlet weak var cnstImgvCheckmarkTrailing : NSLayoutConstraint!
    @IBOutlet weak var cnstImgvArrowTrailing : NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblGuideLine.text = "Select this checkbox and you will see quick\nprogress of this project on home screen"
        
        imgVCheckMark.layer.shadowColor = UIColor.white.cgColor
        imgVCheckMark.layer.shadowOpacity = 1
        imgVCheckMark.layer.shadowOffset = CGSize.zero
        imgVCheckMark.layer.shadowRadius = 10
        imgVCheckMark.layer.shadowPath = UIBezierPath(rect: imgVCheckMark.bounds).cgPath
        imgVCheckMark.layer.cornerRadius = imgVCheckMark.CViewHeight/2
    }
}
