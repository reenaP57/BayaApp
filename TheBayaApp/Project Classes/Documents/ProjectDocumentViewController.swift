//
//  ProjectDocumentViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class ProjectDocumentViewController: ParentViewController {

    @IBOutlet weak var tblMyDoc : UITableView!
    @IBOutlet weak var lblNoData : UILabel!
  
    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrDocument = [[String : AnyObject]]()
    var isFromMyDoc : Bool = false
    var currentPage : Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.hideTabBar()
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        
        self.title =  isFromMyDoc ? "My Documents" : "Project Documents"
  
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        tblMyDoc.pullToRefreshControl = refreshControl
        self.loadDocumentListFromServer(showLoader: true)
    }
}


//MARK
//MARK:- UITableView Delegate and datasource

extension ProjectDocumentViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDocument.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IS_iPad ? CScreenWidth * (84 / 768) : CScreenWidth * (74 / 375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTblCell") as? DocumentTblCell {
            cell.lblTitle.text = arrDocument[indexPath.row].valueForString(key: "documentName")
            
            //...Load More
            if indexPath == tblMyDoc.lastIndexPath() {
              self.loadDocumentListFromServer(showLoader: false)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let pdfLoaderVC = CStoryboardDocument.instantiateViewController(withIdentifier: "LoadPDFViewController") as? LoadPDFViewController {
            pdfLoaderVC.pdfUrl = arrDocument[indexPath.row].valueForString(key: "documentFile")
            self.navigationController?.pushViewController(pdfLoaderVC, animated: false)
        }
        //self.openInSafari(strUrl: arrDocument[indexPath.row].valueForString(key: "documentFile"))
    }
}


//MARK
//MARK:- API Methods

extension ProjectDocumentViewController {
    
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadDocumentListFromServer(showLoader: false)
        
    }
    
    func loadDocumentListFromServer(showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        apiTask = APIRequest.shared().getDocumentList(type: isFromMyDoc ? 1 : 2, page: currentPage, shouldShowLoader: showLoader, completion: { (response, error) in
            
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            
            if response != nil {
                
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    
                    if self.currentPage == 1 {
                        self.arrDocument.removeAll()
                        self.tblMyDoc.reloadData()
                    }
                    
                    if (arrData.count) > 0 {
                        self.arrDocument = self.arrDocument+arrData
                        self.tblMyDoc.reloadData()
                        self.currentPage += 1
                    }
                }
                
                self.lblNoData.isHidden = self.arrDocument.count != 0
            }
        })
    }
}
