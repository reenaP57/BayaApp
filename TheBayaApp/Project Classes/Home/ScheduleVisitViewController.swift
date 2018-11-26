//
//  ScheduleVisitViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

let CharacterLimit = 500
let Gap : CGFloat = IS_iPad ? 15 : 10

class ScheduleVisitViewController: ParentViewController {

    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var txtSlot1 : UITextField! {
        didSet {
            txtSlot1.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtSlot2 : UITextField!{
        didSet {
            txtSlot2.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtSlot3 : UITextField!{
        didSet {
            txtSlot3.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    
    @IBOutlet fileprivate weak var txtNoOfGuest : UITextField!{
        didSet {
            txtNoOfGuest.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtSelectProject : UITextField!{
        didSet {
            txtSelectProject.addRightImageAsRightView(strImgName: "ic_dropdown", rightPadding: 15.0)
        }
    }
    @IBOutlet fileprivate weak var txtVPurpose : UITextView!
        {
        didSet {
            txtVPurpose.placeholderFont = CFontAvenir(size: IS_iPhone ? 14.0 : 18.0, type: .medium).setUpAppropriateFont()
        }
    }
    @IBOutlet fileprivate weak var vwPurpose : UIView!
    @IBOutlet fileprivate weak var imgVBg : UIImageView!
    
    var dateSlot1 = Date()
    var dateSlot2 = Date()
    var dateSlot3 = Date()
    
    var arrProject = [[String : AnyObject]]()
    var projectId = 0
    var projectName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CScheduleVisitScreenName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func checkValidation(txtField : UITextField) {
        
        //...Checked validation for particular textfield when change date
        
        if self.checkSlotTime(date:dateSlot1) {
            txtSlot2.hideValidationMessage(Gap)
            txtSlot3.hideValidationMessage(Gap)
            txtNoOfGuest.hideValidationMessage(Gap)
            txtVPurpose.hideValidationMessage(Gap)
            txtSelectProject.hideValidationMessage(Gap)

            self.vwContent.addSubview(self.txtSlot1.showValidationMessage(Gap,CInvalidTimeRangeMessage))
            
        } else if self.checkSlotTime(date:dateSlot2) {
           
            txtSlot1.hideValidationMessage(Gap)
            txtSlot3.hideValidationMessage(Gap)
            txtNoOfGuest.hideValidationMessage(Gap)
            txtVPurpose.hideValidationMessage(Gap)
            txtSelectProject.hideValidationMessage(Gap)
            self.vwContent.addSubview(self.txtSlot2.showValidationMessage(Gap,CInvalidTimeRangeMessage))
            
        } else if self.checkSlotTime(date:dateSlot3) {
            txtSlot1.hideValidationMessage(Gap)
            txtSlot2.hideValidationMessage(Gap)
            txtNoOfGuest.hideValidationMessage(Gap)
            txtVPurpose.hideValidationMessage(Gap)
            txtSelectProject.hideValidationMessage(Gap)
            self.vwContent.addSubview(self.txtSlot3.showValidationMessage(Gap,CInvalidTimeRangeMessage))

        } else {
           
            if txtField == txtSlot1 {
                txtField.hideValidationMessage(Gap)
            } else if txtField == txtSlot2 {
                txtSlot1.hideValidationMessage(Gap)
                txtField.hideValidationMessage(Gap)
                txtSlot3.hideValidationMessage(Gap)
            } else  if txtField == txtSlot3 {
                txtSlot1.hideValidationMessage(Gap)
                txtSlot2.hideValidationMessage(Gap)
                txtField.hideValidationMessage(Gap)
            }
            
            txtVPurpose.hideValidationMessage(Gap)
            txtNoOfGuest.hideValidationMessage(Gap)
            txtSelectProject.hideValidationMessage(Gap)
        }
    }
    
    func initialize() {
        
        self.title = "Schedule a Visit"
        
        txtSelectProject.text = projectName
        
        GCDMainThread.async {
            self.vwPurpose.layer.masksToBounds = true
            self.vwPurpose.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            self.vwPurpose.layer.shadowOpacity = 5
            self.vwPurpose.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.vwPurpose.layer.shadowRadius = 7
            self.vwPurpose.layer.cornerRadius = 3
        }
        
        self.txtSelectProject.setPickerData(arrPickerData: MIGeneralsAPI.shared().arrProjectList.map({$0[CProjectName]! as! String}), selectedPickerDataHandler: { (string, row, index) in
            self.txtSelectProject.hideValidationMessage(45)
            self.projectId = MIGeneralsAPI.shared().arrProjectList[row].valueForInt(key: CProjectId)!
        }, defaultPlaceholder: "")
        
        txtSlot1.setMinimumDate(minDate:Date().tomorrow)
        txtSlot2.setMinimumDate(minDate:Date().tomorrow)
        txtSlot3.setMinimumDate(minDate:Date().tomorrow)
        
        
        txtSlot1.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: Date().tomorrow , isPrefilledDate: true) { (date) in
            self.dateSlot1 = date
            //txtSlot2.setMinimumDate(minDate: dateSlot1.tomorrow)
            self.checkValidation(txtField: self.txtSlot1)
            
            self.txtSlot2.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: Date().tomorrow, isPrefilledDate: true) { (date) in
                self.dateSlot2 = date
               // txtSlot3.setMinimumDate(minDate: dateSlot2.tomorrow)
                self.checkValidation(txtField: self.txtSlot2)
            }
        }
        
        txtSlot2.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: Date().tomorrow, isPrefilledDate: true) { (date) in
            self.dateSlot2 = date
           // txtSlot3.setMinimumDate(minDate: dateSlot2.tomorrow)
            self.checkValidation(txtField: self.txtSlot2)
            
            self.txtSlot3.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: self.dateSlot2.tomorrow, isPrefilledDate: true) { (date) in
                self.dateSlot3 = date
                self.checkValidation(txtField: self.txtSlot3)
            }
        }
        
        txtSlot3.setDatePickerWithDateFormate(dateFormate: "dd MMMM yyyy hh:mm a", defaultDate: dateSlot2.tomorrow, isPrefilledDate: true) { (date) in
            self.dateSlot3 = date
            self.checkValidation(txtField: self.txtSlot3)
        }
        
        txtNoOfGuest.setPickerData(arrPickerData: ["1","2","3","4","5","6","7","8","9","10"], selectedPickerDataHandler: { (string, row, index) in
            self.txtNoOfGuest.hideValidationMessage(Gap)
        }, defaultPlaceholder: "")
        
    }
    
    func checkSlotTime(date : Date) -> Bool {

        //...Checked selected time validation for > 10 and < 6:30
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        
        if (hour! >= 10 && hour! <= 18) || (hour! == 18 && minute! <= 30){
            return false
        }else{
            return true
        }
    }
    
    func showValidation(isAdd : Bool){
        
        //...Set validation for purpose textView
        self.txtVPurpose.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
        
        if isAdd {
            //... show validation
            txtVPurpose.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            vwPurpose.backgroundColor = CRGB(r: 254, g: 242, b: 242)
            vwPurpose.shadow(color: UIColor.clear, shadowOffset: CGSize(width: 0, height: 0), shadowRadius: 0.0, shadowOpacity: 0.0)
            vwPurpose.layer.borderWidth = 1.0
            vwPurpose.layer.borderColor = CRGB(r: 247, g: 51, b: 52).cgColor
            
        } else {
            //...Hide validation
            txtVPurpose.backgroundColor = UIColor.white
            vwPurpose.backgroundColor = UIColor.white
            vwPurpose.layer.borderWidth = 0.0
            vwPurpose.layer.borderColor = UIColor.white.cgColor
            vwPurpose.shadow(color: CRGB(r: 230, g: 235, b: 239), shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
        
        }
    }
    
    func checkDifferenceBetweenTwoDate() -> Bool {
        //...Checked here for timeslot1, timeslot2 and timeslot3 are not qual
        
        let timeslot1 = "\(DateFormatter.shared().timestampFromDate(date: txtSlot1.text, formate: "dd MMMM yyyy hh:mm a") ?? 0.0)"
        let timeslot2 = "\(DateFormatter.shared().timestampFromDate(date: txtSlot2.text, formate: "dd MMMM yyyy hh:mm a") ?? 0.0)"
        let timeslot3 = "\(DateFormatter.shared().timestampFromDate(date: txtSlot3.text, formate: "dd MMMM yyyy hh:mm a") ?? 0.0)"
        
        if timeslot1 == timeslot2 || timeslot2 == timeslot3 || timeslot1 == timeslot3 {
            return false
        }
        
         return true
    }
}


//MARK:-
//MARK:- Action

extension ScheduleVisitViewController {
    
    @IBAction func btnSubmitClicked (sender : UIButton) {

        GCDMainThread.asyncAfter(deadline: .now() + 0.5) {
            
            if (self.txtSlot1.text?.isBlank)! {
                self.vwContent.addSubview(self.txtSlot1.showValidationMessage(Gap,CBlankTimeSlot1Message))
                
            } else if self.checkSlotTime(date: self.dateSlot1) {
                self.vwContent.addSubview(self.txtSlot1.showValidationMessage(Gap,CInvalidTimeRangeMessage))
            } else if (self.txtSlot2.text?.isBlank)! {
                
                self.txtSlot1.hideValidationMessage(Gap)
                self.vwContent.addSubview(self.txtSlot2.showValidationMessage(Gap,CBlankTimeSlot2Message))
                
            } else if self.checkSlotTime(date: self.dateSlot2) {
                self.txtSlot1.hideValidationMessage(Gap)
                self.vwContent.addSubview(self.txtSlot2.showValidationMessage(Gap,CInvalidTimeRangeMessage))
            } else if (self.txtSlot3.text?.isBlank)! {
                
                self.txtSlot1.hideValidationMessage(Gap)
                self.txtSlot2.hideValidationMessage(Gap)
                self.vwContent.addSubview(self.txtSlot3.showValidationMessage(Gap,CBlankTimeSlot3Message))
                
            } else if self.checkSlotTime(date: self.dateSlot3) {
                self.txtSlot1.hideValidationMessage(Gap)
                self.txtSlot2.hideValidationMessage(Gap)
                self.vwContent.addSubview(self.txtSlot3.showValidationMessage(Gap,CInvalidTimeRangeMessage))
            } else if (self.txtVPurpose.text?.isBlank)! {
                
                self.txtSlot1.hideValidationMessage(Gap)
                self.txtSlot2.hideValidationMessage(Gap)
                self.txtSlot3.hideValidationMessage(Gap)
                self.txtNoOfGuest.hideValidationMessage(Gap)
                self.txtSelectProject.hideValidationMessage(45)
                
                GCDMainThread.async {
                    self.vwContent.addSubview(self.txtVPurpose.showValidationMessage(Gap, CBlankPurposeOfVisitMessage,self.vwPurpose.CViewX, self.vwPurpose.CViewY))
                    self.txtVPurpose.textfiledAddRemoveShadow(true)
                    self.showValidation(isAdd: true)
                }
                _ = self.vwPurpose.setConstraintConstant(IS_iPad ? (20/2) + 20 + lblMessage.frame.size.height :(15/2) + 15 + lblMessage.frame.size.height, edge: .bottom, ancestor: true)
 
            } else if (self.txtNoOfGuest.text?.isBlank)! {
               
                self.txtSlot1.hideValidationMessage(Gap)
                self.txtSlot2.hideValidationMessage(Gap)
                self.txtSlot3.hideValidationMessage(Gap)
               
                self.txtVPurpose.hideValidationMessage(Gap)
                self.showValidation(isAdd: false)
                _ = self.vwPurpose.setConstraintConstant(Gap, edge: .bottom, ancestor: true)
                self.vwContent.addSubview(self.txtNoOfGuest.showValidationMessage(Gap,CBlankNoOfGuestMessage))
                
            } else if (self.txtSelectProject.text?.isBlank)! {
               
                self.txtSlot1.hideValidationMessage(Gap)
                self.txtSlot2.hideValidationMessage(Gap)
                self.txtSlot3.hideValidationMessage(Gap)
                self.txtNoOfGuest.hideValidationMessage(Gap)

                self.txtVPurpose.hideValidationMessage(Gap)
                self.showValidation(isAdd: false)
                _ = self.vwPurpose.setConstraintConstant(Gap, edge: .bottom, ancestor: true)
                self.vwContent.addSubview(self.txtSelectProject.showValidationMessage(30.0,CSelectProjectMessage))
              
                
            } else if !self.checkDifferenceBetweenTwoDate() {
                
                self.showAlertView(CDuplicateTimeSlotMessage, completion: { (result) in
                })
            }
            else {
                self.scheduleVisit()
            }
        }
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension ScheduleVisitViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.hideValidationMessage(Gap)
        self.showValidation(isAdd: false)
        _ = self.vwPurpose.setConstraintConstant(Gap, edge: .bottom, ancestor: true)

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

}


//MARK:-
//MARK:- API

extension ScheduleVisitViewController {
    
    func scheduleVisit() {
        
        let timeslot1 = "\(DateFormatter.shared().timestampFromDate(date: txtSlot1.text, formate: "dd MMMM yyyy hh:mm a") ?? 0.0)"
        let timeslot2 = "\(DateFormatter.shared().timestampFromDate(date: txtSlot2.text, formate: "dd MMMM yyyy hh:mm a") ?? 0.0)"
        let timeslot3 = "\(DateFormatter.shared().timestampFromDate(date: txtSlot3.text, formate: "dd MMMM yyyy hh:mm a") ?? 0.0)"

        
        let dict = ["projectId" : self.projectId,
                    "timeSlot1" : timeslot1,
                    "timeSlot2" : timeslot2,
                    "timeSlot3" : timeslot3,
                    "purpose" : txtVPurpose.text,
                    "guests" : txtNoOfGuest.text!] as [String : Any]

        //...Called api for post schedule visit detail on server

        APIRequest.shared().scheduleVisit(dict: dict as [String : AnyObject]) { (response, error) in

            if response != nil && error == nil {
                self.imgVBg.isHidden = false
                self.showAlertView(CSuccessScheduleVisitMessage, completion: { (result) in
                    if result {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            } else {
                self.imgVBg.isHidden = true
            }
        }
        
    }
}
