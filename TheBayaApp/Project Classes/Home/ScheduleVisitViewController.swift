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

    @IBOutlet fileprivate weak var vwContent : UIView!
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

    var dateSlot1 = Date()
    var dateSlot2 = Date()
    var dateSlot3 = Date()
    
    
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
            dateSlot1 = date
        }
        
        txtSlot2.setDatePickerWithDateFormate(dateFormate: "dd-MM-yyyy hh:mm", defaultDate: Date().tomorrow, isPrefilledDate: false) { (date) in
            dateSlot2 = date
        }
        
        txtSlot3.setDatePickerWithDateFormate(dateFormate: "dd-MM-yyyy hh:mm", defaultDate: Date().tomorrow, isPrefilledDate: false) { (date) in
            dateSlot3 = date
        }
        
        txtNoOfGuest.setPickerData(arrPickerData: ["1","2","3","4","5","6","7","8","9","10"], selectedPickerDataHandler: { (string, row, index) in
        }, defaultPlaceholder: "")
        
        txtSelectProject.setPickerData(arrPickerData: ["The Baya Victoria","The Baya Victoria1","The Baya Victoria2"], selectedPickerDataHandler: { (string, row, index) in
        }, defaultPlaceholder: "")
        
        txtSlot1.setMinimumDate(minDate: Date().tomorrow)
        txtSlot2.setMinimumDate(minDate: Date().tomorrow)
        txtSlot3.setMinimumDate(minDate: Date().tomorrow)
        
    }
    
    func checkSlotTime(date : Date) -> Bool {
        
        //date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        // Get current time and format it to compare
        let currentTimeStr = dateFormatter.string(from: date)
        let currentTime = dateFormatter.date(from: currentTimeStr)
        
        let startTime = dateFormatter.date(from: "10:00 AM")
        let endTime = dateFormatter.date(from: "6:30 PM")
        
        if currentTime! > startTime! && currentTime! < endTime!  {
            return false
        }
        
        return true
    }
}


//MARK:-
//MARk:- Action

extension ScheduleVisitViewController {
    
    @IBAction func btnSubmitClicked (sender : UIButton) {
        
        for objView in vwContent.subviews{
            if  objView.isKind(of: UITextField.classForCoder()){
                let txField = objView as? UITextField
                txField?.hideValidationMessage(15.0)
                txField?.resignFirstResponder()
            }
            
            if  objView.isKind(of: UITextView.classForCoder()){
                let txView = objView as? UITextView
                txView?.hideValidationMessage(15.0)
                txView?.resignFirstResponder()
            }
        }
        
        self.view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            
            if (self.txtSlot1.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSlot1.showValidationMessage(15.0,CBlankTimeSlot1Message))
                
            } else if (self.txtSlot2.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSlot2.showValidationMessage(15.0,CBlankTimeSlot2Message))
                
            } else if (self.txtSlot3.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSlot3.showValidationMessage(15.0,CBlankTimeSlot3Message))
                
            } else if (self.txtVPurpose.text?.isBlank)! {
                self.vwContent.addSubview(self.txtVPurpose.showValidationMessage(15.0,CBlankPurposeOfVisitMessage))
                
            } else if (self.txtNoOfGuest.text?.isBlank)! {
                self.vwContent.addSubview(self.txtNoOfGuest.showValidationMessage(15.0,CBlankNoOfGuestMessage))
                
            } else if (self.txtSelectProject.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSelectProject.showValidationMessage(15.0,CSelectProjectMessage))
                
            } else if (self.txtSlot1.text == self.txtSlot2.text) ||  (self.txtSlot2.text == self.txtSlot3.text) || (self.txtSlot1.text == self.txtSlot3.text) {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CDuplicateTimeSlotMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
            } else if self.checkSlotTime(date: self.dateSlot1) ||
                self.checkSlotTime(date: self.dateSlot2) ||
                self.checkSlotTime(date: self.dateSlot3) {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CInvalidTimeRangeMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
            } else {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CSuccessScheduleVisitMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
            }
        }
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
