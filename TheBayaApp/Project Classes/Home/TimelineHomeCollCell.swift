//
//  TimelineHomeCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 04/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TimelineHomeCollCell: UICollectionViewCell {
    
    @IBOutlet weak var lblBadge : UILabel!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblPrjctName : UILabel!
    @IBOutlet weak var imgVTitle : UIImageView!
    @IBOutlet weak var progressVCom : UIProgressView!
    @IBOutlet weak var lblPercentage : UILabel!
    @IBOutlet weak var vwProgress : UIView!
    @IBOutlet weak var vwCount : UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressVCom.progressImage = #imageLiteral(resourceName: "progress")
        
        lblBadge.layer.cornerRadius = lblBadge.CViewHeight/2
        lblBadge.layer.masksToBounds = true
        
        progressVCom.layer.cornerRadius = progressVCom.CViewHeight/2
        progressVCom.layer.masksToBounds = true
    }
}
