//
//  ExtensionUITableView.swift
//  EasyExchange
//
//  Created by Mac-00014 on 26/02/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit

extension UITableView {

    var pullToRefreshControl: UIRefreshControl? {
        get {
            if #available(iOS 10.0, *) {
                return self.refreshControl
            } else {
                return self.viewWithTag(9876) as? UIRefreshControl
            }
        } set {
            if #available(iOS 10.0, *) {
                self.refreshControl = newValue
            } else {
                if let refreshControl = newValue {
                    refreshControl.tag = 9876
                    self.addSubview(refreshControl)
                }
            }
        }
    }
    
    func lastIndexPath() -> IndexPath?
    {
        let sections = self.numberOfSections
        
        if (sections<=0){
            return nil
        }
        
        let rows = self.numberOfRows(inSection: sections-1)
        
        if (rows<=0){return nil}
        
        return IndexPath(row: rows-1, section: sections-1)
    }
}
