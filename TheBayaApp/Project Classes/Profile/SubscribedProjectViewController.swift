//
//  SubscribedProjectViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 14/08/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class SubscribedProjectViewController: ParentViewController {

    @IBOutlet fileprivate weak var tblSubscribedList : UITableView!
    
    var arrSubscribeList = [[String : AnyObject]]()
    
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
        self.title = "Subscribed Projects"
        
        arrSubscribeList = [["project_name" : "The Baya Victoria", "location" :"203 Orbital Plaza, Prabhadevi Road, Mumbai 400 025"],
        ["project_name" : "The Baya Junction", "location" :"203 Orbital Plaza, Prabhadevi Road, Mumbai 400 025"],
        ["project_name" : "TDR Kanjurmarg", "location" :"203 Orbital Plaza, Prabhadevi Road, Mumbai 400 025"],
        ["project_name" : "The Baya Victoria", "location" :"203 Orbital Plaza, Prabhadevi Road, Mumbai 400 025"]] as [[String : AnyObject]]
    }
}


//MARK:-
//MARK:- UITableView Delegate and Datasource

extension SubscribedProjectViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubscribeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_iPad ? CScreenWidth * (115 / 768) : CScreenWidth * (108 / 375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscribedTblCell") as? SubscribedTblCell {
            
            let dict = arrSubscribeList[indexPath.row]
            cell.lblProjectName.text = dict.valueForString(key: "project_name")
            cell.lblAddress.text = dict.valueForString(key: "location")
            
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            
            cell.btnUnsubscribe.touchUpInside { (sender) in
                
                self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CUnsubscribeMessage, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
                }, btnTwoTitle: CBtnNo) { (action) in
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

}
