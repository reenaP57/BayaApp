//
//  VisitDetailsViewController.swift
//  TheBayaApp
//
//  Created by Mind-0006 on 09/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class VisitDetailsViewController: ParentViewController {

    @IBOutlet weak var tblVVisitDetails: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.navigationItem.title = "Visit Details"
    }

}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension VisitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailTblCell") as? VisitDetailTblCell {
            return cell
        }
        
        return UITableViewCell()

//        let cell = tblVVisitDetails.dequeueReusableCell(withIdentifier: "TblCellVisitDetails")
//
//        switch indexPath.row {
//        case 0:
//            if let btnrating = cell?.viewWithTag(101) as? UIButton {
//                btnrating.hide(byHeight: true)
//            }
//        case 2 :
//            if let btnrating = cell?.viewWithTag(101) as? UIButton {
//                btnrating.isHidden = true
//            }
//            if let viewRating = cell?.viewWithTag(100) {
//                viewRating.backgroundColor = .orange
//            }
//
//        default:
//            break
//        }
//
//        return cell!
    }
    
}
