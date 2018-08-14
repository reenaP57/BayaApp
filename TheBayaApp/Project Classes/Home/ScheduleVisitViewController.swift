//
//  ScheduleVisitViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

let CharacterLimit = 500

class ScheduleVisitViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtSlot1 : UITextField!
    @IBOutlet fileprivate weak var txtSlot2 : UITextField!
    @IBOutlet fileprivate weak var txtSlot3 : UITextField!
    @IBOutlet fileprivate weak var txtNoOfGuest : UITextField!
    @IBOutlet fileprivate weak var txtSelectProject : UITextField!
    @IBOutlet fileprivate weak var txtVPurpose : UITextView! {
        didSet {
            txtVPurpose.placeholderFont = CFontAvenirLTStd(size: 15.0, type: .medium)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    
    func initialize() {
        
        self.title = "Schedule a Visit"
        
        txtSlot1.setDatePickerWithDateFormate(dateFormate: "dd-MM-yyyy hh:mm", defaultDate: Date().tomorrow , isPrefilledDate: false) { (date) in
        }
        
        txtSlot2.setDatePickerWithDateFormate(dateFormate: "dd-MM-yyyy hh:mm", defaultDate: Date().tomorrow, isPrefilledDate: false) { (date) in
        }
        
        txtSlot3.setDatePickerWithDateFormate(dateFormate: "dd-MM-yyyy hh:mm", defaultDate: Date().tomorrow, isPrefilledDate: false) { (date) in
        }
        
        txtNoOfGuest.setPickerData(arrPickerData: ["1","2","3","4","5","6","7","8","9","10"], selectedPickerDataHandler: { (string, row, index) in
        }, defaultPlaceholder: "")
        
        txtSelectProject.setPickerData(arrPickerData: ["The Baya Victoria","The Baya Victoria1","The Baya Victoria2"], selectedPickerDataHandler: { (string, row, index) in
        }, defaultPlaceholder: "")
        
        txtSlot1.setMinimumDate(minDate: Date().tomorrow)
        txtSlot2.setMinimumDate(minDate: Date().tomorrow)
        txtSlot3.setMinimumDate(minDate: Date().tomorrow)
    }
}


//MARK:-
//MARk:- Action

extension ScheduleVisitViewController {
    
    @IBAction func btnSubmitClicked (sender : UIButton) {
        
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension ScheduleVisitViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0 {
            textView.placeholderColor = UIColor.clear
        } else {
            textView.placeholderColor = ColorGray
        }
        
        if textView.text.count > CharacterLimit {
            let currentText = textView.text as NSString
            txtVPurpose.text = currentText.substring(to: currentText.length - 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            return false
        }
        
        return true
    }
}
