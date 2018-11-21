//
//  RequestDocumentListViewController.swift
//  TheBayaApp
//
//  Created by mac-00017 on 29/10/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

class RequestDocumentListViewController: ParentViewController {

    @IBOutlet weak var tblRequestDoc : UITableView!
    @IBOutlet weak var lblNoData : UILabel!
    @IBOutlet weak var btnAddRequest : UIButton!

    var refreshControl = UIRefreshControl()
    var apiTask : URLSessionTask?
    var arrRequest = [[String : AnyObject]]()
    var currentPage : Int = 1
    fileprivate var lastPage : Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialize()
    }

    
    //MARK:-
    //MARK:- General Methods
    
    func initialize() {
        self.title = "Request a Document"
        
        btnAddRequest.shadow(color: ColorGreenSelected, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 7, shadowOpacity: 5)
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = ColorGreenSelected
        tblRequestDoc.pullToRefreshControl = refreshControl
        self.loadDocumentRequestFromServer(showLoader: true)
        
        tblRequestDoc.rowHeight = UITableViewAutomaticDimension
        tblRequestDoc.estimatedRowHeight = 110
    }
}

//MARK
//MARK:- UITableView Delegate and datasource

extension RequestDocumentListViewController {
   
    @IBAction func btnAddRequestClicked() {
        if let addRequestVC = CStoryboardDocument.instantiateViewController(withIdentifier: "AddRequestDocViewController") as? AddRequestDocViewController {
            self.navigationController?.pushViewController(addRequestVC, animated: true)
        }
    }
}

//MARK
//MARK:- UITableView Delegate and datasource

extension RequestDocumentListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDocTblCell") as? RequestDocTblCell {
            
            let dict = arrRequest[indexPath.row]
            cell.lblDocName.text = dict.valueForString(key: "documentName")
            cell.lblRequestedDate.text = "Requested on: \(DateFormatter.dateStringFrom(timestamp: dict.valueForDouble(key: "createdAt")!, withFormate: "dd MMM yyyy"))"
            
            switch dict.valueForInt(key: "requestStatus") {
            case CRequestOpen : //...Open
                cell.vwStatus.backgroundColor = ColorParrotColor
                cell.lblStatus.text = CDocRequestOpen
            case CRequestCompleted : //...Completed
                cell.vwStatus.backgroundColor = ColorGreenSelected
                cell.lblStatus.text = CDocRequestCompleted
            case CRequestInProgress : //...In Progress
                cell.vwStatus.backgroundColor = ColorOrange
                cell.lblStatus.text = CDocRequestInProgress
            case CRequestRejected : //...Rejected
                cell.vwStatus.backgroundColor = ColorRed
                cell.lblStatus.text = CDocRequestRejected
            default :
                break
            }
            
            if indexPath == tblRequestDoc.lastIndexPath() {
                //...Load More
                if currentPage <= lastPage {
                    if apiTask?.state != URLSessionTask.State.running {
                        self.loadDocumentRequestFromServer(showLoader: false)
                    }
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewRequestVC = CStoryboardDocument.instantiateViewController(withIdentifier: "ViewRequestViewController") as? ViewRequestViewController {
            viewRequestVC.docID = arrRequest[indexPath.row].valueForInt(key: "id") ?? 0
            self.navigationController?.pushViewController(viewRequestVC, animated: true)
        }
    }
}

//MARK:-
//MARK:- API Method

extension RequestDocumentListViewController {
 
    @objc func pullToRefresh() {
        currentPage = 1
        refreshControl.beginRefreshing()
        self.loadDocumentRequestFromServer(showLoader: false)
    }
    
    func loadDocumentRequestFromServer(showLoader : Bool) {
        
        if apiTask?.state == URLSessionTask.State.running {
            return
        }
        
        apiTask = APIRequest.shared().getDocumentRequest(page: currentPage, shouldShowLoader: showLoader, completion: { (response, error) in
            
            self.refreshControl.endRefreshing()
            self.apiTask?.cancel()
            
            if response != nil {
                
                if self.currentPage == 1 {
                    self.arrRequest.removeAll()
                }
                
                if let arrData = response?.value(forKey: CJsonData) as? [[String : AnyObject]] {
                    if arrData.count > 0 {
                        self.arrRequest = self.arrRequest+arrData
                    }
                }
                
                if let metaData = response?.value(forKey: CJsonMeta) as? [String : AnyObject] {
                    self.lastPage = metaData.valueForInt(key: CLastPage)!
                    
                    if metaData.valueForInt(key: CCurrentPage)! <= self.lastPage {
                        self.currentPage = metaData.valueForInt(key: CCurrentPage)! + 1
                    }
                }
                
                self.lblNoData.isHidden = self.arrRequest.count != 0
                self.tblRequestDoc.reloadData()
            }
        })
    }
}
