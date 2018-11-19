//
//  ViewRequestViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ViewRequestViewController: ParentViewController {

    @IBOutlet weak var lblDocName : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblRequesetedDate : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var vwStatus : UIView!
    @IBOutlet weak var vwRejected : UIView!
    @IBOutlet weak var vwContent : UIView!

    var docID : Int = 0
    var strRejectMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    //MARK:-
    //MARK:- General Method
    
    func initialize() {
        
        self.title = "View Request"
        self.loadDocumentDetail()
    }
    
    func setDocumentDetail(dict : [String : AnyObject]) {
       
        vwContent.isHidden = false 
        lblDocName.text = dict.valueForString(key: "documentName")
        lblRequesetedDate.text = "Requested on: \(DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: "createdAt")!, withFormate: "dd MMM yyyy"))"
        lblDesc.text = dict.valueForString(key: "message")
        strRejectMsg = dict.valueForString(key: "rejectReason")
        
        if dict.valueForInt(key: "requestStatus") == CRequestRejected {
            vwRejected.isHidden = false
        } else {
            vwStatus.isHidden = false
        }
        
        switch dict.valueForInt(key: "requestStatus") {
        case CRequestOpen : //...Open
            vwStatus.backgroundColor = ColorParrotColor
            lblStatus.text = CDocRequestOpen
        case CRequestCompleted : //...Completed
            vwStatus.backgroundColor = ColorGreenSelected
            lblStatus.text = CDocRequestCompleted
        case CRequestInProgress : //...In Progress
            vwStatus.backgroundColor = ColorOrange
            lblStatus.text = CDocRequestInProgress
        case CRequestRejected : //...Rejected
            vwStatus.backgroundColor = ColorRed
            lblStatus.text = CDocRequestRejected
        default :
            break
        }
    }
}


//MARK:-
//MARk:- Action

extension ViewRequestViewController {
    
    @IBAction func btnInfoClicked(sender : UIButton) {
        
        let infoView = InfoView.initInfoView()
        
        infoView.lblInfo.text = strRejectMsg
        infoView.alpha = 0.0
        infoView.vwContent.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            appDelegate.window.addSubview(infoView)
        }, completion: { (completed) in
            
            UIView.animate(withDuration: 0.5, animations: {
                infoView.alpha = 1.0
                infoView.vwContent.alpha = 1.0
            })
        })
        
        infoView.btnClose.touchUpInside { (btnInfo) in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                infoView.alpha = 0.0
                infoView.vwContent.alpha = 0.0
                
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.5, animations: {
                    infoView.removeFromSuperview()
                })
            })
        }
    }
}


//MARK:-
//MARk:- API Method

extension ViewRequestViewController {
    
    func loadDocumentDetail() {
        
        APIRequest.shared().viewDocumentRequest(docID: self.docID) { (response, error) in
            if response != nil {
                self.setDocumentDetail(dict: (response?.value(forKey: CJsonData) as! [String : AnyObject]))
            }
        }
    }
}
