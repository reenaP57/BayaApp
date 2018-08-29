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
    @IBOutlet weak var lblCompleted : UILabel!
    @IBOutlet weak var btnCall : UIButton!
    @IBOutlet weak var btnSubscribe : MIGenericButton!
    @IBOutlet weak var imgVProgress : UIImageView!
    @IBOutlet weak var imgVPjctCompletion : UIImageView!
    @IBOutlet weak var imgVDottedLine : UIImageView!
    @IBOutlet weak var cnstlblPercentageCenter : NSLayoutConstraint!
    @IBOutlet weak var cnstImgvDottedBottom : NSLayoutConstraint!
    @IBOutlet weak var btnProjectDetail : UIButton!
    @IBOutlet weak var btnScheduleVisit : UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblPercentage.layer.cornerRadius = 5
        lblPercentage.layer.masksToBounds = true
    }
}
