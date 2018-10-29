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
    
    var dictRequest = [String : AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    func initialize() {
        
        self.title = "View Request"
        
        lblDocName.text = dictRequest.valueForString(key: "docName")
        lblRequesetedDate.text = "Requested on : \(dictRequest.valueForString(key: "date"))"
        lblDesc.text = dictRequest.valueForString(key: "desc")
        
        if dictRequest.valueForString(key: "status") == CRequestRejected {
            vwStatus.isHidden = true
        } else {
            vwRejected.isHidden = true
            lblStatus.text = dictRequest.valueForString(key: "status")
            
            switch dictRequest.valueForString(key: "status") {
            case CRequestOpen : //...Open
                vwStatus.backgroundColor = ColorParrotColor
            case CRequestCompleted : //...Completed
                vwStatus.backgroundColor = ColorGreenSelected
            default : //...In Progress
                vwStatus.backgroundColor = ColorOrange
            }
        }
    }
}


//MARK:-
//MARk:- Action

extension ViewRequestViewController {
    
    @IBAction func btnInfoClicked(sender : UIButton) {
        
        let infoView = InfoView.initInfoView()
        
        infoView.lblInfo.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        
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
