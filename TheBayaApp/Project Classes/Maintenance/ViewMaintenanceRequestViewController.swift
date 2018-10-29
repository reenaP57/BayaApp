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

    var status = "" //Temp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    
    func initialize() {
        
        self.title = "View Maintenance Request"
        
        switch status {
        case CRequestOpen : //...Open
            vwStatus.backgroundColor = ColorParrotColor
        case CRequestCompleted : //...Completed
            vwStatus.backgroundColor = ColorGreenSelected
        default : //...In Progress
            vwStatus.backgroundColor = ColorOrange
        }
        
        lblStatus.text = status
    }
}
