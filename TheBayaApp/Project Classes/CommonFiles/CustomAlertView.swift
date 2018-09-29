//
//  CustomAlertView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 15/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    @IBOutlet weak var lblMsg : UILabel!
    @IBOutlet weak var btnOk : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    
    class func initAlertView() -> CustomAlertView {
        let alertView : CustomAlertView = Bundle.main.loadNibNamed(IS_iPad ? "CustomAlertView_ipad" : "CustomAlertView", owner: nil, options: nil)?.last as! CustomAlertView
        alertView.frame = CGRect(x: 0.0, y: 0.0, width: CScreenWidth, height: CScreenHeight)
        alertView.layoutIfNeeded()
        return alertView
    }

}
