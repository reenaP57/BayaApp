//
//  LocationAdvantagesCollCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 16/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class LocationAdvantagesCollCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVLocation : UIImageView!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var tblLocDesc : UITableView!

    var arrLocDesc = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadLocationDesc(arrDesc : [String]) {
        
        if arrDesc.count > 0{
            arrLocDesc = arrDesc
            tblLocDesc.reloadData()
            
//            cnstHeightTbl.constant = tblLocDesc.contentSize.height
//
//            print("Height :", cnstHeightTbl)
        }
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension LocationAdvantagesCollCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocDesc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDescTblCell") as? LocationDescTblCell {
            
            cell.lblLocation.text = arrLocDesc[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}
