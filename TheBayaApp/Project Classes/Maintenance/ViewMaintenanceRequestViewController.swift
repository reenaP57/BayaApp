//
//  ViewMaintenanceRequestViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ViewMaintenanceRequestViewController: ParentViewController {

    @IBOutlet weak var lblType : UILabel!
    @IBOutlet weak var lblSubject : UILabel!
    @IBOutlet weak var lblRequesetedDate : UILabel!
    @IBOutlet weak var lblDesc : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var vwImg : UIView!
    @IBOutlet weak var vwStatus : UIView!

    var barButton: UIBarButtonItem!

    var status = "" //Temp
    var isFromRate : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if isFromRate {
             //...If user come from rate screen that time it will be redirect on maintenance list screen
            
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = nil
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(btnBackClicked))
        }
    }

    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title = "View Maintenance Request"
        
//        switch status {
//        case CRequestOpen : //...Open
//            vwStatus.backgroundColor = ColorParrotColor
//        case CRequestCompleted : //...Completed
//            vwStatus.backgroundColor = ColorGreenSelected
//        default : //...In Progress
//            vwStatus.backgroundColor = ColorOrange
//        }
        
        lblStatus.text = status
        
        if status == "" {
            vwStatus.backgroundColor = ColorGreenSelected
            lblStatus.text = "COMPLETED"
        }
    }
    
    @objc func btnBackClicked() {
        
        for vwController in (self.navigationController?.viewControllers)! {
            
            if vwController.isKind(of: MaintenanceViewController.classForCoder()){
                
                if let maintenanceVC = vwController as? MaintenanceViewController {
                    self.navigationController?.popToViewController(maintenanceVC, animated: true)
                }
                break
            }
        }
    }
}
