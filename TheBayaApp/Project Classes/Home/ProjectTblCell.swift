//
//  ProjectTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProjectTblCell: UITableViewCell {

    @IBOutlet weak var lblPjctName : UILabel!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblReraNo : UILabel!
    @IBOutlet weak var imgVPrjct : UIImageView!
    @IBOutlet weak var btnSubscribe : MIGenericButton!
    @IBOutlet weak var viewMainContainer : UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSubscribe.layer.cornerRadius = 5
        btnSubscribe.layer.masksToBounds = true
        
        self.viewMainContainer.shadow(color: UIColor.black, shadowOffset: CGSize(width: 0, height: 2), shadowRadius: 3.0, shadowOpacity: 0.5)

        self.contentView.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
