//
//  FilterView.swift
//  TheBayaApp
//
//  Created by mac-00017 on 13/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class FilterView: UIView {

    @IBOutlet weak var btnClose : UIButton!
    @IBOutlet weak var btnDone : UIButton!
    @IBOutlet weak var btnClear : UIButton!
    @IBOutlet weak var txtStartDate : UITextField!
    @IBOutlet weak var txtEndDate : UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtStartDate.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15.0)
        txtEndDate.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15.0)
        
        txtStartDate.setDatePickerWithDateFormate(dateFormate: "DD/MM/YYYY", defaultDate: Date(), isPrefilledDate: false) { (date) in
        }
        
        txtEndDate.setDatePickerWithDateFormate(dateFormate: "DD/MM/YYYY", defaultDate: Date(), isPrefilledDate: false) { (date) in
        }
        
        self.roundCorners([.topLeft, .topRight], radius: 30)
    }
}
