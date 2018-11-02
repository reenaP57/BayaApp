//
//  RateYoorVisitViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class RateYoorVisitViewController: ParentViewController {

    @IBOutlet fileprivate weak var txtVFeedback : UITextView!{
        didSet {
            txtVFeedback.placeholderFont = CFontAvenir(size: IS_iPhone ? 14.0 : 18.0, type: .medium).setUpAppropriateFont()
        }
    }
    
    @IBOutlet fileprivate weak var vwRating : FloatRatingView! {
        didSet {
            vwRating.delegate = self
            vwRating.rating = 0.0
        }
    }
    
    @IBOutlet fileprivate weak var vwContent : UIView!
    @IBOutlet fileprivate weak var vwReview : UIView! {
        didSet {
            vwReview.layer.masksToBounds = true
            vwReview.layer.shadowColor = CRGB(r: 230, g: 235, b: 239).cgColor
            vwReview.layer.shadowOpacity = 5
            vwReview.layer.shadowOffset = CGSize(width: 0, height: 3)
            vwReview.layer.shadowRadius = 7
            vwReview.layer.cornerRadius = 3
        }
    }
    @IBOutlet fileprivate weak var imgVBg : UIImageView!
    @IBOutlet fileprivate weak var btnSkip : UIButton!
    @IBOutlet fileprivate weak var lblNote : UILabel!

    var isVisitRate : Bool = false
    var visitId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
        
        if isVisitRate {
            MIGoogleAnalytics.shared().trackScreenNameForGoogleAnalytics(screenName: CRateScreenName)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
 
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
       
        if isVisitRate {
            //...Rate Visit
            self.navigationItem.title = "Rate Your Visit"
            txtVFeedback.placeholder = "Your feedback on visit"
            lblNote.text = "Please spare few minutes to rate your visit. Your feedback is valuable to us."
            btnSkip.isHidden = true
        } else {
            //...Rate Maintenance
            self.navigationItem.title = "Rate Maintenance"
            txtVFeedback.placeholder = "Your feedback on maintenance work"
            lblNote.text = "Please spare few minutes to rate our service. Your feedback is valuable to us."
        }
    }
}


//MARK:-
//MARK:- Action

extension RateYoorVisitViewController {
    
    @IBAction fileprivate func btnSkipClicked (sender : UIButton) {
        if let viewMaintenanceVC = CStoryboardMaintenance.instantiateViewController(withIdentifier: "ViewMaintenanceRequestViewController") as? ViewMaintenanceRequestViewController {
            viewMaintenanceVC.isFromRate = true
            
            self.navigationController?.pushViewController(viewMaintenanceVC, animated: true)
        }
    }
    
    @IBAction fileprivate func btnSubmitClicked (sender : UIButton) {
        
        for objView in vwContent.subviews{
            if  objView.isKind(of: UITextField.classForCoder()){
                let txField = objView as? UITextField
                txField?.hideValidationMessage(15.0)
                txField?.resignFirstResponder()
            }
        }
        self.view.layoutIfNeeded()
        DispatchQueue.main.async {
            
            if self.vwRating.rating < 1.0 {
                self.showAlertView(CSelectRating, completion: { (result) in
                })
            } else {
                
                if self.isVisitRate {
                    //...Rate Visit
                    self.rateVisit()
                } else {
                    //...Rate Maintenance
                    
                    self.showAlertView(CSuccessRateVisitMessage) { (result) in
                        
                        if let viewMaintenanceVC = CStoryboardMaintenance.instantiateViewController(withIdentifier: "ViewMaintenanceRequestViewController") as? ViewMaintenanceRequestViewController {
                           
                           viewMaintenanceVC.isFromRate = true
                            self.navigationController?.pushViewController(viewMaintenanceVC, animated: true)
                        }
                    }
                }
            }
        }
    }
}


//MARK:-
//MARK:- TextView Delegate Method

extension RateYoorVisitViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 0 {
            textView.placeholderColor = UIColor.clear
        } else {
            textView.placeholderColor = ColorGray
        }
        
        if textView.text.count > CharacterLimit {
            let currentText = textView.text as NSString
            txtVFeedback.text = currentText.substring(to: currentText.length - 1)
        }
    }

}


//MARK:-
//MARK:- Floating Rating Delegate Method

extension RateYoorVisitViewController : FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        print("Rating : ",vwRating.rating)
    }
}


//MARK:-
//MARK:- API

extension RateYoorVisitViewController {
    
    func rateVisit() {
        
        APIRequest.shared().rateVisit(visitId: self.visitId, rating: Int(vwRating.rating), desc: txtVFeedback.text) { (response, error) in
            
            if response != nil && error == nil {
                self.imgVBg.isHidden = false
                self.showAlertView(CSuccessRateVisitMessage, completion: { (result) in
                    
                    if result {
                        
                        for vwController in (self.navigationController?.viewControllers)! {
                            
                            if vwController.isKind(of: VisitDetailsViewController .classForCoder()){
                                
                                let visitDetail = vwController as? VisitDetailsViewController
                                visitDetail?.RefreshRatingVisit(visitId: self.visitId, rating : Int(self.vwRating.rating))
                                self.navigationController?.popViewController(animated: true)
                                break
                                
                            } else if vwController.isKind(of: NotificationViewController .classForCoder()){
                                
                                let notificationVC = vwController as? NotificationViewController
                                notificationVC?.isFromOtherScreen = true
                                self.navigationController?.popViewController(animated: true)
                                break
                                
                            } else {
                                self.navigationController?.popViewController(animated: true)
                                break
                            }
                        }
                    }
                })
            } else{
                self.imgVBg.isHidden = true
            }
        }
    }
}
