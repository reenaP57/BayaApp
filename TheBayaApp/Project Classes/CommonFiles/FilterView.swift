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
    @IBOutlet weak var vwContent : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtStartDate.setDatePickerWithDateFormate(dateFormate: "dd MMMM YYYY", defaultDate: Date(), isPrefilledDate: true) { (date) in
        }
        
        txtEndDate.setDatePickerWithDateFormate(dateFormate: "dd MMMM YYYY", defaultDate: Date(), isPrefilledDate: true) { (date) in
        }
    }
}
