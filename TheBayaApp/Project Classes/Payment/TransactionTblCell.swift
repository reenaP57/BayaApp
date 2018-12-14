//
//  TransactionTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 31/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TransactionTblCell: UITableViewCell {

    @IBOutlet weak var lblMilestoneName : UILabel!
    @IBOutlet weak var lblPaymentDate : UILabel!
    @IBOutlet weak var lblDueDate : UILabel!
    @IBOutlet weak var lblAmountPaid : UILabel!
    @IBOutlet weak var lblGSTPaid : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
