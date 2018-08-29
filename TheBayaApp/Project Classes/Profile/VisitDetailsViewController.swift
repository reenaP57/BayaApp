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
    
    var arrVisitList = [[String : AnyObject]]()
    
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
        self.navigationItem.title = "Visit Details"
        
        arrVisitList = [["project_name":"Baya Victoria", "time":"25 July 2018 at 5:00 PM.", "visit_type":"recently", "rated": true],
                        ["project_name":"Baya Victoria", "time":"25 July 2018 at 5:00 PM.", "visit_type":"past", "rated": true],
                        ["project_name":"Baya Victoria", "time":"25 July 2018 at 5:00 PM.", "visit_type":"past", "rated": false]] as [[String : AnyObject]]
        
        tblVVisitDetails.estimatedRowHeight = 125
        tblVVisitDetails.rowHeight = UITableViewAutomaticDimension
    }

}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension VisitDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVisitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VisitDetailTblCell") as? VisitDetailTblCell {
            
            let dict = arrVisitList[indexPath.row]
            
            cell.lblProjectName.text = dict.valueForString(key: "project_name")
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            if dict.valueForString(key: "visit_type") == "past" {
               cell.lblTimeMsg.text = "You have visited this project on \(dict.valueForString(key: "time"))"
                
                cell.btnRateVisit.isHidden = dict.valueForBool(key: "rated")
                cell.vwRating.isHidden = !dict.valueForBool(key: "rated")
                
            } else {
                cell.lblTimeMsg.text = "Your visit has been scheduled for \(dict.valueForString(key: "time"))"
               
               _ = cell.lblTimeMsg.setConstraintConstant(10, edge: .centerY, ancestor: true)
                cell.btnRateVisit.isHidden = true
                cell.vwRating.isHidden = true
            }
            
            
            cell.btnRateVisit.touchUpInside { (sender) in
                
                if let rateVisitVC = CStoryboardProfile.instantiateViewController(withIdentifier: "RateYoorVisitViewController") as? RateYoorVisitViewController {
                    self.navigationController?.pushViewController(rateVisitVC, animated: true)
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
