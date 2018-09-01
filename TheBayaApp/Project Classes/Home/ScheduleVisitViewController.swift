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
    @IBOutlet fileprivate weak var txtSlot1 : UITextField! {
        didSet {
            txtSlot1.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtSlot2 : UITextField!{
        didSet {
            txtSlot2.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtSlot3 : UITextField!{
        didSet {
            txtSlot3.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15.0)
        }
    }
    
    @IBOutlet fileprivate weak var txtNoOfGuest : UITextField!{
        didSet {
            txtNoOfGuest.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtSelectProject : UITextField!{
        didSet {
            txtSelectProject.addRightImageAsRightView(strImgName: "dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtVPurpose : UITextView!
        {
        didSet {
            txtVPurpose.placeholderFont = CFontAvenir(size: IS_iPhone ? 14.0 : 18.0, type: .medium).setUpAppropriateFont()
        }
    }
    @IBOutlet fileprivate weak var vwPurpose : UIView!{
        didSet {
            vwPurpose.layer.masksToBounds = true
            vwPurpose.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            vwPurpose.layer.shadowOpacity = 5
            vwPurpose.layer.shadowOffset = CGSize(width: 0, height: 3)
            vwPurpose.layer.shadowRadius = 7
            vwPurpose.layer.cornerRadius = 3
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
    
    func checkValidation(txtField : UITextField) {
  
        if self.checkSlotTime(date:dateSlot1) {
            txtSlot2.hideValidationMessage(15.0)
            txtSlot3.hideValidationMessage(15.0)
            txtNoOfGuest.hideValidationMessage(15.0)
            txtVPurpose.hideValidationMessage(15.0)
            txtSelectProject.hideValidationMessage(15.0)

            self.vwContent.addSubview(self.txtSlot1.showValidationMessage(15.0,CInvalidTimeRangeMessage))
            
        } else if self.checkSlotTime(date:dateSlot2) {
           
            txtSlot3.hideValidationMessage(15.0)
            txtNoOfGuest.hideValidationMessage(15.0)
            txtVPurpose.hideValidationMessage(15.0)
            txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtSlot2.showValidationMessage(15.0,CInvalidTimeRangeMessage))
            
        } else if self.checkSlotTime(date:dateSlot3) {
            txtNoOfGuest.hideValidationMessage(15.0)
            txtVPurpose.hideValidationMessage(15.0)
            txtSelectProject.hideValidationMessage(15.0)
            self.vwContent.addSubview(self.txtSlot3.showValidationMessage(15.0,CInvalidTimeRangeMessage))

        } else {
           
            if txtField == txtSlot1 {
                txtField.hideValidationMessage(15.0)
            } else if txtField == txtSlot2 {
                txtSlot1.hideValidationMessage(15.0)
                txtField.hideValidationMessage(15.0)
                txtSlot3.hideValidationMessage(15.0)
            } else  if txtField == txtSlot3 {
                txtSlot1.hideValidationMessage(15.0)
                txtSlot2.hideValidationMessage(15.0)
                txtField.hideValidationMessage(15.0)
            }
            
            txtVPurpose.hideValidationMessage(15.0)
            txtNoOfGuest.hideValidationMessage(15.0)
            txtSelectProject.hideValidationMessage(15.0)
        }
    }
    
    func initialize() {
        
        self.title = "Schedule a Visit"
        
        
        txtSlot1.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: Date().tomorrow , isPrefilledDate: true) { (date) in
            dateSlot1 = date
            self.checkValidation(txtField: txtSlot1)
        }
        
        txtSlot2.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: Date().tomorrow, isPrefilledDate: true) { (date) in
            dateSlot2 = date
            self.checkValidation(txtField: txtSlot2)
        }
        
        txtSlot3.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: Date().tomorrow, isPrefilledDate: true) { (date) in
            dateSlot3 = date
            self.checkValidation(txtField: txtSlot3)
        }
        
        txtNoOfGuest.setPickerData(arrPickerData: ["1","2","3","4","5","6","7","8","9","10"], selectedPickerDataHandler: { (string, row, index) in
           txtNoOfGuest.hideValidationMessage(15.0)
        }, defaultPlaceholder: "")
        
        txtSelectProject.setPickerData(arrPickerData: ["The Baya Victoria","The Baya Victoria1","The Baya Victoria2"], selectedPickerDataHandler: { (string, row, index) in
           txtSelectProject.hideValidationMessage(15.0)
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
        
//        for objView in vwContent.subviews{
//            if  objView.isKind(of: UITextField.classForCoder()){
//                let txField = objView as? UITextField
//                txField?.hideValidationMessage(15.0)
//                txField?.resignFirstResponder()
//            }
//
//            if  objView.isKind(of: UITextView.classForCoder()){
//                let txView = objView as? UITextView
//                txView?.hideValidationMessage(15.0)
//                txView?.resignFirstResponder()
//            }
//        }
//
//        self.view.layoutIfNeeded()
//
//        DispatchQueue.main.async {
        
            if (self.txtSlot1.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSlot1.showValidationMessage(15.0,CBlankTimeSlot1Message))
                
            } else if self.checkSlotTime(date: self.dateSlot1) {
                self.vwContent.addSubview(self.txtSlot1.showValidationMessage(15.0,CInvalidTimeRangeMessage))
            } else if (self.txtSlot2.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSlot2.showValidationMessage(15.0,CBlankTimeSlot2Message))
                
            } else if self.checkSlotTime(date: self.dateSlot2) {
                self.vwContent.addSubview(self.txtSlot2.showValidationMessage(15.0,CInvalidTimeRangeMessage))
            } else if (self.txtSlot3.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSlot3.showValidationMessage(15.0,CBlankTimeSlot3Message))
                
            } else if self.checkSlotTime(date: self.dateSlot3) {
                self.vwContent.addSubview(self.txtSlot3.showValidationMessage(15.0,CInvalidTimeRangeMessage))
            } else if (self.txtVPurpose.text?.isBlank)! {
               
                self.txtNoOfGuest.hideValidationMessage(15.0)
                self.txtSelectProject.hideValidationMessage(15.0)
                self.vwContent.addSubview(self.txtVPurpose.showValidationMessage(15.0,CBlankPurposeOfVisitMessage))
                
            } else if (self.txtNoOfGuest.text?.isBlank)! {
                self.vwContent.addSubview(self.txtNoOfGuest.showValidationMessage(15.0,CBlankNoOfGuestMessage))
                
            } else if (self.txtSelectProject.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSelectProject.showValidationMessage(15.0,CSelectProjectMessage))
                
            } else if (self.txtSlot1.text == self.txtSlot2.text) ||  (self.txtSlot2.text == self.txtSlot3.text) || (self.txtSlot1.text == self.txtSlot3.text) {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CDuplicateTimeSlotMessage, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
            }  else {
                
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CSuccessScheduleVisitMessage, btnOneTitle: CBtnOk, btnOneTapped: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
       // }
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension ScheduleVisitViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.hideValidationMessage(15.0)
        
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
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        if text == "\n" {
//            return false
//        }
//        
//        return true
//    }
}
