//
//  SubscribedTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SubscribedTblCell: UITableViewCell {

    @IBOutlet weak var lblProjectName : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var btnUnsubscribe : UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
