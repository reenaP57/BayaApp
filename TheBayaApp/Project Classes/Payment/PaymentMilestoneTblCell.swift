//
//  PaymentMilestoneTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 30/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class PaymentMilestoneTblCell: UITableViewCell {

    @IBOutlet var lblPercent : UILabel!
    @IBOutlet var lblAmount : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var vwSeparater : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
