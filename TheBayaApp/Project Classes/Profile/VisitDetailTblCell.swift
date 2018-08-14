//
//  VisitDetailTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class VisitDetailTblCell: UITableViewCell {

    @IBOutlet weak var lblProjectName : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var imgVProject : UIImageView!
    @IBOutlet weak var btnRateVisit : UIButton!
    @IBOutlet weak var vwRating : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
