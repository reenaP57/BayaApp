//
//  RequestDocTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class RequestDocTblCell: UITableViewCell {

    @IBOutlet weak var lblDocName : UILabel!
    @IBOutlet weak var lblRequestedDate : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var vwStatus : UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   }

}
