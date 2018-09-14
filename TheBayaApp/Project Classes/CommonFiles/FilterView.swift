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

    class func initFilterView() -> FilterView{
        let filterView:FilterView = Bundle.main.loadNibNamed(IS_iPad ? "FilterView_ipad" : "FilterView", owner: nil, options: nil)?.last as! FilterView
        filterView.frame = CGRect(x: 0.0, y: 0.0, width: CScreenWidth, height: CScreenHeight)
        filterView.layoutIfNeeded()
        return filterView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        txtStartDate.setDatePickerMode(mode: .date)
        txtEndDate.setDatePickerMode(mode: .date)

        txtStartDate.setDatePickerWithDateFormate(dateFormate: "dd MMMM YYYY", defaultDate: Date(), isPrefilledDate: true) { (date) in
        }
        
        txtEndDate.setDatePickerWithDateFormate(dateFormate: "dd MMMM YYYY", defaultDate: Date(), isPrefilledDate: true) { (date) in
        }
    }
    
}
