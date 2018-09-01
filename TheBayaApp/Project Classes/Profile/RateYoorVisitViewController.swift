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
        self.navigationItem.title = "Rate Your Visit"
    }
}


//MARK:-
//MARK:- Action

extension RateYoorVisitViewController {
    
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
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CSelectRating, btnOneTitle: CBtnOk, btnOneTapped: nil)
                
            } else {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: CSuccessRateVisitMessage, btnOneTitle: CBtnOk) { (action) in
                    self.navigationController?.popViewController(animated: true)
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
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        if text == "\n" {
//            return false
//        }
//
//        return true
//    }
}


//MARK:-
//MARK:- Floating Rating Delegate Method

extension RateYoorVisitViewController : FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        print("Rating : ",vwRating.rating)
    }
}
