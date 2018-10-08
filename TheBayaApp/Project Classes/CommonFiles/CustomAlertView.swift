//
//  CustomAlertView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 15/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

enum AlertType:Int {
    case alertView
    case confirmationView
}

class CustomAlertView: UIView {

    @IBOutlet weak var lblMsg : UILabel!
    @IBOutlet weak var btnOk : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var vwLine : UIView!

    class func initAlertView() -> CustomAlertView {
        let alertView : CustomAlertView = Bundle.main.loadNibNamed(IS_iPad ? "CustomAlertView_ipad" : "CustomAlertView", owner: nil, options: nil)?.last as! CustomAlertView
        alertView.frame = CGRect(x: 0.0, y: 0.0, width: CScreenWidth, height: CScreenHeight)
        alertView.layoutIfNeeded()
        return alertView
    }
    
    func showAlert(_ message : String?, okTitle: String?, cancleTitle: String?, type : AlertType, completion: ((Bool) -> Void)?) {
        
        if type == .alertView {
            self.btnCancel.hide(byWidth: true)
            self.vwLine.isHidden = true
            _ = self.btnOk.setConstraintConstant(-(self.btnOk.CViewX + self.btnOk.CViewWidth), edge: .leading, ancestor: true)
        
        }
        
        self.lblMsg.text = message
    }

}
