//
//  ProjectViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 10/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProjectViewController: ParentViewController {

    @IBOutlet fileprivate weak var tblProject : UITableView!
    
    var arrProject = [[String : AnyObject]]()
    
    
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

    func initialize() {
        self.title = "The Baya Projects"
        
        arrProject = [["project_name": "The Baya Victoria", "location" : "203 Orbital Plaza, Prabhadevi Road, Mumbai 400 025", "desc" : "The Baya Victoria is a perfect blend of convenient location and modern amenities", "rera_no" :"P51900013240","img" : "img1.jpeg"],
                      ["project_name": "The Baya Victoria", "location" : "203 Orbital Plaza, Prabhadevi Road, Mumbai 400 025", "desc" : "The Baya Victoria is a perfect blend of convenient location and modern amenities", "rera_no" :"P51900013240","img" : "img2.jpeg"],["project_name": "The Baya Victoria", "location" : "203 Orbital Plaza, Prabhadevi Road, Mumbai 400 025", "desc" : "The Baya Victoria is a perfect blend of convenient location and modern amenities", "rera_no" :"P51900013240","img" : "img3.jpeg"]] as [[String : AnyObject]]
    }
}


extension ProjectViewController : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTblCell") as? ProjectTblCell {
            
            let dict = arrProject[indexPath.row]
      
            cell.lblPjctName.text = dict.valueForString(key: "project_name")
            cell.lblLocation.text = dict.valueForString(key: "location")
            cell.lblDesc.text = dict.valueForString(key: "desc")
            cell.lblReraNo.text = dict.valueForString(key: "rera_no")
            cell.imgVPrjct.image = UIImage(named: dict.valueForString(key: "img"))
            
            return cell
        }
        
        return UITableViewCell()
    }
}
