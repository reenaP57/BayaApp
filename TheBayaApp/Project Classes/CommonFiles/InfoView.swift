//
//  InfoView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class InfoView: UIView {

    @IBOutlet var lblInfo : UILabel!
    @IBOutlet var btnClose : UIButton!
    @IBOutlet var vwContent : UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func initInfoView() -> InfoView {
        
        let infoView:InfoView = Bundle.main.loadNibNamed(IS_iPad ? "InfoView_ipad" : "InfoView", owner: nil, options: nil)?.last as! InfoView
        infoView.frame = CGRect(x: 0.0, y: 0.0, width: CScreenWidth, height: CScreenHeight)
        return infoView
    }
}
