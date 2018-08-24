//
//  TutorialCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class TutorialCollCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVTutorial : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDesc : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if IS_iPhone_6_Plus {
           _ = imgVTutorial.setConstraintConstant(imgVTutorial.CViewY + 40, edge: .top, ancestor: true)
        }
    }
    
}
