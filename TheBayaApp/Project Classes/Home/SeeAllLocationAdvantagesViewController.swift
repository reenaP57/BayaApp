//
//  SeeAllLocationAdvantagesViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SeeAllLocationAdvantagesViewController: ParentViewController {
    
    @IBOutlet fileprivate weak var tblLocation : UITableView!
    
    var arrLocation = [[String : AnyObject]]()
    
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
        self.title = "Location Advantages"
        
        arrLocation = [["img" : "metro", "title" : "Metro", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km","VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]],
                       ["img" : "malls", "title" : "Malls", "desc" : ["Alfa One 2.0 km"]],
                       ["img" : "Hospital", "title" : "Hospitals", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km","VT Station 1.5 km", "Dadar Station 1.0 km"]],
                       ["img" : "schools", "title" : "Schools", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]],
                       ["img" : "metro", "title" : "Metro", "desc" : ["VT Station 1.5 km", "Dadar Station 1.0 km", "Vile Parle 1.0 km"]]] as [[String : AnyObject]]
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            self.tblLocation.reloadData()
        }
    }
}


//MARK:-
//MARK:- UITableview Delegate and Datsource

extension SeeAllLocationAdvantagesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocation.count
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 137
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SellAllLocationTblCell") as? SellAllLocationTblCell {
            
            let dict = arrLocation[indexPath.row]
            
            cell.lblLocation.text = dict.valueForString(key: "title")
            cell.imgVLocation.image = UIImage(named: dict.valueForString(key: "img"))
            cell.loadLocationDesc(arrDesc: dict.valueForJSON(key: "desc") as! [String])

            return cell
        }
        
        return UITableViewCell()
    }
}
