//
//  DocumentViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 26/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class DocumentViewController: ParentViewController {

    @IBOutlet weak var tblDocument : UITableView!
    
    var arrDocument = [["img" : IS_iPad ? "ic_my-documents" : "ic_my-documents", "title" : "My Documents"],
                       ["img" : IS_iPad ? "my_projects_profile_ipad" : "my_projects_profile", "title" : "Project Documents"],
                       ["img" : IS_iPad ? "visit_details_profile_ipad" : "visit_details_profile", "title" : "Request a Document"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Documents"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
}

//MARK
//MARK:- UITableView Delegate and datasource

extension DocumentViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDocument.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_iPad ? CScreenWidth * (84 / 768) : CScreenWidth * (74 / 375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTblCell") as? ProfileTblCell {
            
            cell.lblTitle.text = arrDocument[indexPath.row].valueForString(key: "title")
            cell.imgVTitle.image = UIImage(named: arrDocument[indexPath.row].valueForString(key: "img"))
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row {
        case 0,1:
            if let documentVC = CStoryboardDocument.instantiateViewController(withIdentifier: "ProjectDocumentViewController") as? ProjectDocumentViewController {
                documentVC.isFromMyDoc = indexPath.row == 0 ? true : false
                self.navigationController?.pushViewController(documentVC, animated: true)
            }
            
        default:
            if let requestDocVC = CStoryboardDocument.instantiateViewController(withIdentifier: "RequestDocumentListViewController") as? RequestDocumentListViewController {
                self.navigationController?.pushViewController(requestDocVC, animated: true)
            }
        }
    }
}
