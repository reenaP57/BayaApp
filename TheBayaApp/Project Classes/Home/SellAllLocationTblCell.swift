//
//  SellAllLocationTblCell.swift
//  TheBayaApp
//
//  Created by mac-00017 on 18/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SellAllLocationTblCell: UITableViewCell {
    
    @IBOutlet weak var imgVLocation : UIImageView!
    @IBOutlet weak var lblLocation : UILabel!
    @IBOutlet weak var tblLocDesc : UITableView!
    @IBOutlet weak var cnstHeightTbl : NSLayoutConstraint!
    
    var arrLocDesc = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func loadLocationDesc(arrDesc : [String]) {
        
        if arrDesc.count > 0{
            arrLocDesc = arrDesc
            tblLocDesc.reloadData()
            
            if #available(iOS 11.0, *) {
                tblLocDesc.performBatchUpdates({
                    self.cnstHeightTbl.constant = self.tblLocDesc.contentSize.height
                }) { (completed) in
                    self.cnstHeightTbl.constant = self.tblLocDesc.contentSize.height
                }
            } else {
                // Fallback on earlier versions
                self.cnstHeightTbl.constant = self.tblLocDesc.contentSize.height
            }

        }
    }

}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension SellAllLocationTblCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLocDesc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDescTblCell") as? LocationDescTblCell {
            
            cell.lblLocation.text = arrLocDesc[indexPath.row]
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        
        return UITableViewCell()
    }
}
