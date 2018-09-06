//
//  SubscribedProjectCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 13/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SubscribedProjectCollCell: UICollectionViewCell {
    
    @IBOutlet weak var lblProjectName : UILabel!
    @IBOutlet weak var lblPercentage : UILabel!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var lblReraNo: UILabel!
    @IBOutlet weak var btnCall : UIButton!
    @IBOutlet weak var btnSubscribe : MIGenericButton!
    @IBOutlet weak var imgVProgress : UIImageView!
    @IBOutlet weak var imgVPjctCompletion : UIImageView!
    @IBOutlet weak var imgVDottedLine : UIImageView!
    @IBOutlet weak var cnstlblPercentageCenter : NSLayoutConstraint!
    @IBOutlet weak var cnstImgvDottedBottom : NSLayoutConstraint!
    @IBOutlet weak var btnProjectDetail : UIButton!
    @IBOutlet weak var btnScheduleVisit : UIButton!
    @IBOutlet weak var vwSoldOut : UIView!
    @IBOutlet weak var vwContainer : UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblPercentage.layer.cornerRadius = 5
        lblPercentage.layer.masksToBounds = true
        
        self.vwContainer.shadow(color: UIColor.black, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 3.0, shadowOpacity: 0.5)

        vwSoldOut.layer.borderWidth = 1
        vwSoldOut.layer.borderColor = CRGB(r: 255, g: 0, b: 0).cgColor
    }
}
