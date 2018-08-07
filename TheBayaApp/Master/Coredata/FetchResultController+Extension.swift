//
//  FetchResultController+Extension.swift
//  DemoSwift
//
//  Created by mac-0007 on 05/09/16.
//  Copyright © 2016 Jignesh-0007. All rights reserved.
//

import Foundation
import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



typealias BlockNumberOfSections       = () -> Int
typealias BlockNumberOfRows           = (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) -> Int
typealias BlockNumberOfItems          = (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) -> Int

typealias BlockHeightForHeader        = (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) -> (CGFloat)
typealias BlockHeightForFooter        = (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) -> (CGFloat)
typealias BlockHeightForRow           = (_ indexPath:IndexPath) -> (CGFloat)
typealias BlockHeightForItem          = (_ indexPath:IndexPath, _ item:AnyObject?) -> (CGFloat)

typealias BlockIdentifierForHeader    = (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) -> (String)
typealias BlockIdentifierForFooter    = (_ sectionIndex:Int, _ info:NSFetchedResultsSectionInfo?) -> (String)
typealias BlockIdentifierForRow       = (_ indexPath:IndexPath, _ item:AnyObject?) -> (String)
typealias BlockIdentifierForItem      = (_ indexPath:IndexPath, _ item:AnyObject?) -> (String)

typealias BlockCellForRow             = (_ indexPath:IndexPath, _ cell:AnyObject?, _ object:AnyObject?) -> (Void)
typealias BlockCellForItem            = (_ indexPath:IndexPath, _ cell:AnyObject?, _ object:AnyObject?) -> (Void)

typealias BlockCellForRowWithSection  = (_ indexPath:IndexPath, _ cell:AnyObject?, _ object:AnyObject?, _ section:AnyObject?, _ info:NSFetchedResultsSectionInfo?) -> (Void)

typealias BlockViewForHeader          = (_ section:UIView?, _ index:Int, _ info:NSFetchedResultsSectionInfo?) -> (Void)
typealias BlockViewForFooter          = (_ section:UIView?, _ index:Int, _ info:NSFetchedResultsSectionInfo?) -> (Void)

typealias BlockDidSelectRow           = (_ indexPath:IndexPath, _ cell:AnyObject?, _ object:AnyObject?) -> (Void)
typealias BlockDidDeselectRow         = (_ indexPath:IndexPath, _ cell:AnyObject?, _ object:AnyObject?) -> (Void)

typealias BlockFetchResultDelegate    = (_ arrInserted:NSArray?, _ arrUpdated:NSArray?, _ arrDeleted:NSArray?) -> (Void)




class DataSourceController: NSObject, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate
{
    lazy var blockNumberOfSections:BlockNumberOfSections? = nil
    
    lazy var blockNumberOfRows:BlockNumberOfRows? = nil
    
    lazy var blockNumberOfItems:BlockNumberOfItems? = nil
    
    lazy var blockHeightForHeader:BlockHeightForHeader? = nil
    
    lazy var blockHeightForFooter:BlockHeightForFooter? = nil
    
    lazy var blockHeightForRow:BlockHeightForRow? = nil
    
    lazy var blockHeightForItem:BlockHeightForItem? = nil
    
    lazy var blockIdentifierForHeader:BlockIdentifierForHeader? = nil
    
    lazy var blockIdentifierForFooter:BlockIdentifierForFooter? = nil
    
    lazy var blockIdentifierForRow:BlockIdentifierForRow? = nil
    
    lazy var blockIdentifierForItem:BlockIdentifierForItem? = nil
    
    lazy var blockCellForRow:BlockCellForRow? = nil
    
    lazy var blockCellForItem:BlockCellForItem? = nil
    
    lazy var blockCellForRowWithSection:BlockCellForRowWithSection? = nil
    
    lazy var blockViewForHeader:BlockViewForHeader? = nil
    
    lazy var blockViewForFooter:BlockViewForFooter? = nil
    
    lazy var blockDidSelectRow:BlockDidSelectRow? = nil
    
    lazy var blockDidDeselectRow:BlockDidDeselectRow? = nil
    
    lazy var blockFetchResultDelegate:BlockFetchResultDelegate? = nil
    
    lazy var blockVoid:BlockVoid? = nil
    
    
    
    var cellIdentifier:String?
    
    var headerIdentifier:String?
    
    var footerIdentifier:String?
    
    var headerSize:CGSize?
    
    var footerSize:CGSize?
    
    var indexEnabled:Bool?
    
    
    
    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>?
    
    fileprivate var tableView:UITableView?
    
    fileprivate var collectionView:UICollectionView?
    
    lazy fileprivate var isLoaded:Bool = false
    
    
    
    lazy var _arrInserted                = NSMutableArray()
    lazy var _arrUpdated                 = NSMutableArray()
    lazy var _arrDeleted                 = NSMutableArray()
    lazy var _arrRelationshipKeyPaths    = NSMutableArray()
    
    
    
    
    
    
    //MARK:-
    //MARK:- Init Deinit and Overrided
    
    override init() {
        super.init()
    }
    
    convenience init(listView view:UIView?, fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>?, delegateBlock: BlockFetchResultDelegate?, voidBlock: BlockVoid?)
    {
        self.init()
        
        if (view != nil)
        {
            if (view is UITableView)
            {
                self.tableView = view as? UITableView
                
                if (self.tableView?.rowHeight == 0 && self.tableView?.estimatedRowHeight == 0) {
                    self.tableView?.estimatedRowHeight = 44.0
                }
                
                if (self.tableView?.sectionHeaderHeight == 0 && self.tableView?.estimatedSectionHeaderHeight == 0) {
                    self.tableView?.estimatedSectionHeaderHeight = 30.0
                }
            }
            else if (view is UICollectionView) {
                self.collectionView = view as? UICollectionView
            }
        }
        
        self.blockFetchResultDelegate = delegateBlock!
        self.blockVoid = voidBlock!
        
        if (fetchedResultsController != nil) {
            self.fetchedResultsController = fetchedResultsController
        }
    }
    
    deinit
    {
        self.fetchedResultsController = nil
        self.tableView = nil
        self.collectionView = nil
    }
    
    override func responds(to aSelector: Selector) -> Bool
    {
        switch aSelector
        {
            
        case #selector(UITableViewDelegate.tableView(_:heightForRowAt:)):
            return (self.blockHeightForRow != nil || self.blockHeightForItem != nil)
            
        case #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:)):
            return (self.blockHeightForHeader != nil)
            
        case #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:)):
            return (self.blockHeightForFooter != nil)
            
        case #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:)):
            return (self.blockViewForHeader != nil)
            
        case #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:)):
            return (self.blockViewForFooter != nil)
            
        case #selector(NSFetchedResultsControllerDelegate.controller(_:didChange:at:`for`:newIndexPath:)):
            return (self.blockFetchResultDelegate != nil)
            
        default:
            break
            
        }
        
        return super.responds(to: aSelector)
    }
    
    
    
    
    
    //MARK:-
    //MARK:- General Method
    
    func setRelationshipKeyPaths(keyPaths:[String]?) -> Void
    {
        self.setRelationshipKeyPaths(sectionKeyPaths: keyPaths, shouldReload: false)
    }
    
    func setRelationshipKeyPaths(predicateKeyPath predicates:[String]?) -> Void
    {
        self.setRelationshipKeyPaths(sectionKeyPaths: predicates, shouldReload: true)
    }
    
    func setRelationshipKeyPaths(sortDescriptors:[NSSortDescriptor]?) -> Void
    {
        var keyPaths = [String]()
        
        for sortDescriptor in sortDescriptors!
        {
            if (sortDescriptor.key?.components(separatedBy: ".").count > 1) {
                keyPaths.append(sortDescriptor.key!)
            }
        }
        
        self.setRelationshipKeyPaths(sectionKeyPaths: keyPaths, shouldReload: true)
    }
    
    func setRelationshipKeyPaths(sectionKeyPaths:[String]?, shouldReload:Bool?) -> Void
    {
        let mainEntity:NSEntityDescription = (self.fetchedResultsController?.fetchRequest.entity)!
        var entityToCheck:NSEntityDescription = mainEntity
        
        for keyPath in sectionKeyPaths!
        {
            let array = keyPath.components(separatedBy: ".")
            
            if (array.count <= 1) {
                return
            }
            
            var relationship:NSRelationshipDescription?
            var attribute:String?
            
            for i in 0 ..< array.count
            {
                let property: NSPropertyDescription = entityToCheck.propertiesByName[array[i]]!
                
                if (property is NSRelationshipDescription)
                {
                    relationship = property as? NSRelationshipDescription
                    entityToCheck = (relationship?.destinationEntity)!
                }
                else if (property is NSAttributeDescription)
                {
                    attribute = array[i]
                }
                
                
                if (i == (array.count - 1))
                {
                    let arrResult:NSArray? = _arrRelationshipKeyPaths.filtered(using: NSPredicate(format: "entity == %@", (relationship?.destinationEntity?.name)!)) as NSArray
                    
                    let dictionary = NSMutableDictionary()
                    
                    if (arrResult != nil && arrResult!.count > 0)
                    {
                        dictionary.setDictionary(arrResult?.firstObject as! [AnyHashable: Any])
                        _arrRelationshipKeyPaths.remove(dictionary)
                    }
                    
                    if (attribute != nil)
                    {
                        let predicate = NSPredicate(format: "%K != nil", attribute!)
                        
                        dictionary.setValue(relationship?.destinationEntity?.name, forKey: "entity")
                        
                        if shouldReload == true {
                            dictionary.setValue(true, forKey: "reloadData")
                        }
                        
                        if (arrResult != nil && arrResult!.count > 0)
                        {
                            let dict = arrResult?.firstObject
                            
                            dictionary.setValue(((dict as AnyObject).value(forKey: "changes") != nil) ? NSCompoundPredicate(orPredicateWithSubpredicates: [(dict as AnyObject).value(forKey: "changes") as! NSPredicate, predicate]) : predicate, forKey: "changes")
                        }
                        else
                        {
                            dictionary.setValue(predicate, forKey: "changes")
                        }
                    }
                    
                    _arrRelationshipKeyPaths.add(dictionary)
                }
            }
            
        }
    }
    
    func observeRelationshipUpdates() -> Void
    {
        for dictionary in _arrRelationshipKeyPaths as! [NSDictionary]
        {
            let changesPredicate = dictionary.value(forKey: "changes") as! NSPredicate
            let entity = dictionary.value(forKey: "entity") as! String
            let reloadData = dictionary.value(forKey: "reloadData") as! Bool
            
            (NSClassFromString(entity) as! NSManagedObject.Type).changedObjects(changeType: .update, predicate: nil, changePredicate: changesPredicate, block: {
                
                if (reloadData) {
                    self.loadData()
                } else {
                    let visibleItems:[IndexPath] = (self.tableView?.indexPathsForVisibleRows)!
                    
                    for indexPath in visibleItems
                    {
                        let item = self.item(indexPath: indexPath) as! NSManagedObject
                        item.managedObjectContext?.refresh(item, mergeChanges: false)
                        break
                    }
                }
            })
        }
    }
    
    
    func loadData() -> Void
    {
        self.fetchedResultsController?.managedObjectContext.performSafeBlock(block: {
            
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {}
            
            self.reloadData()
        })
        
        if !isLoaded
        {
            if (self.fetchedResultsController?.sectionNameKeyPath != nil)
            {
                self.setRelationshipKeyPaths(sectionKeyPaths: [(self.fetchedResultsController?.sectionNameKeyPath)!], shouldReload: true)
            }
            
            self.setRelationshipKeyPaths(sortDescriptors: self.fetchedResultsController?.fetchRequest.sortDescriptors)
            self.observeRelationshipUpdates()
            isLoaded = true
        }
    }
    
    fileprivate func reloadData() -> Void
    {
        if (self.blockFetchResultDelegate != nil) {
            self.blockFetchResultDelegate!(_arrInserted, _arrUpdated, _arrDeleted)
        } else if (self.blockVoid != nil) {
            self.blockVoid!()
        }
        
        if (self.tableView != nil)
        {
            self.tableView?.dataSource = self
            self.tableView?.delegate = self
            
            if Thread.isMainThread {
                self.tableView?.reloadData()
            }
            else
            {
                DispatchQueue.main.async(execute: { 
                    self.tableView?.reloadData()
                })
            }
        }
        
        if (self.collectionView != nil)
        {
            self.collectionView?.dataSource = self
            self.collectionView?.delegate = self
            
            if Thread.isMainThread {
                self.collectionView?.reloadData()
            }
            else
            {
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
            }
        }
        
    }
    
    
    
    
    //MARK:- 
    //MARK:- Update Query
    
    func change(fetchLimit:Int) -> Void
    {
        if (self.fetchedResultsController?.fetchRequest.fetchLimit == fetchLimit) {
            return
        }
        
        let fetchRequest = self.fetchedResultsController?.fetchRequest
        fetchRequest?.fetchLimit = fetchLimit
        
        if (self.fetchedResultsController?.cacheName != nil) {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: self.fetchedResultsController?.cacheName)
        }
        
        self.loadData()
    }
    
    func change(predicate:NSPredicate?) -> Void
    {
        let fetchRequest = self.fetchedResultsController?.fetchRequest
        
        if ((fetchRequest?.predicate?.isEqual(predicate)) == true) {
            return
        }
        
        fetchRequest?.predicate = predicate
        
        if (self.fetchedResultsController?.cacheName != nil) {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: self.fetchedResultsController?.cacheName)
        }
        
        self.loadData()
    }
    
    func change(sortDescriptors:[NSSortDescriptor]) -> Void
    {
        let fetchRequest = self.fetchedResultsController?.fetchRequest
        
        if ((fetchRequest?.sortDescriptors)! == sortDescriptors) {
            return
        }
        
        fetchRequest?.sortDescriptors = sortDescriptors
        
        if (self.fetchedResultsController?.cacheName != nil) {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: self.fetchedResultsController?.cacheName)
        }
        
        self.loadData()
        self.setRelationshipKeyPaths(sortDescriptors: sortDescriptors)
    }
    
    func change(entity name:String?, predicate:NSPredicate?) -> Void
    {
        let fetchRequest = self.fetchedResultsController?.fetchRequest
        
        if (fetchRequest?.entity?.name == name && fetchRequest?.predicate == predicate) {
            return
        }
        
        fetchRequest?.entity = NSEntityDescription.entity(forEntityName: name!, in: (self.fetchedResultsController?.managedObjectContext)!)
        fetchRequest?.predicate = predicate
        
        if (self.fetchedResultsController?.cacheName != nil) {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: self.fetchedResultsController?.cacheName)
        }
        
        self.loadData()
    }
    
    func change(entity name:String?, predicate:NSPredicate?, sortDescriptors:[NSSortDescriptor]?, cellIdentifier:String?) -> Void
    {
        let fetchRequest = self.fetchedResultsController?.fetchRequest
        
        if (fetchRequest?.entity?.name == name && fetchRequest?.predicate == predicate && (fetchRequest?.sortDescriptors)! == sortDescriptors!) {
            return
        }
        
        fetchRequest?.entity = NSEntityDescription.entity(forEntityName: name!, in: (self.fetchedResultsController?.managedObjectContext)!)
        fetchRequest?.predicate = predicate
        fetchRequest?.sortDescriptors = sortDescriptors
        
        self.cellIdentifier = cellIdentifier
        
        fetchRequest?.sortDescriptors = sortDescriptors
        
        if (self.fetchedResultsController?.cacheName != nil) {
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: self.fetchedResultsController?.cacheName)
        }
        
        self.loadData()
        self.setRelationshipKeyPaths(sortDescriptors: sortDescriptors)
    }
    
    
    
    
    //MARK:-
    //MARK:- tableview and collectionview datasource
    
    
    func item(indexPath:IndexPath) -> AnyObject?
    {
        if (self.fetchedResultsController != nil)
        {
            let object = self.fetchedResultsController?.object(at: indexPath) as? NSManagedObject
                return object
        }
        
        return nil
    }
    
    func sectionInfo(index:Int) -> NSFetchedResultsSectionInfo?
    {
        if (self.fetchedResultsController != nil)
        {
            let section = self.fetchedResultsController?.sections![index]
            return section
        }
        
        return nil
    }
    
    fileprivate func numberOfSections() -> Int
    {
        if (self.blockNumberOfSections != nil) {
            return self.blockNumberOfSections!()
        }
        else if (self.fetchedResultsController != nil)
        {
            let count = self.fetchedResultsController?.sections?.count
            return count!
        }
        else {
            return 0
        }
    }
    
    fileprivate func heightForHeader(section:Int) -> CGFloat
    {
        if (self.blockHeightForHeader != nil) {
            return self.blockHeightForHeader!(section, self.sectionInfo(index: section))
        } else {
            return self.tableView!.sectionHeaderHeight
        }
    }
    
    fileprivate func heightForFooter(section:Int) -> CGFloat
    {
        if (self.blockHeightForFooter != nil) {
            return self.blockHeightForFooter!(section, self.sectionInfo(index: section))
        } else {
            return self.tableView!.sectionFooterHeight
        }
    }
    
    fileprivate func numberOfRows(section:Int) -> Int
    {
        if (self.blockNumberOfRows != nil) {
            return self.blockNumberOfRows!(section, self.sectionInfo(index: section))
        } else if(self.blockNumberOfItems != nil) {
            return self.blockNumberOfItems!(section, self.sectionInfo(index: section))
        } else {
            return (self.sectionInfo(index: section)?.numberOfObjects)!
        }
    }
    
    fileprivate func heightForRow(indexPath:IndexPath) -> CGFloat
    {
        if (self.blockHeightForRow != nil) {
            return self.blockHeightForRow!(indexPath)
        } else if(self.blockHeightForItem != nil) {
            return self.blockHeightForItem!(indexPath, self.item(indexPath: indexPath))
        } else {
            return self.tableView!.rowHeight
        }
    }
    
    fileprivate func cellIdentifier(indexPath:IndexPath) -> String
    {
        if (self.blockIdentifierForRow != nil) {
            return self.blockIdentifierForRow!(indexPath, self.item(indexPath: indexPath)!)
        } else if(self.blockIdentifierForItem != nil) {
            return self.blockIdentifierForItem!(indexPath, self.item(indexPath: indexPath)!)
        } else {
            return self.cellIdentifier!
        }
    }
    
    fileprivate func sectionIdentifierForHeader(section:Int) -> String
    {
        if (self.blockIdentifierForHeader != nil) {
            return self.blockIdentifierForHeader!(section, self.sectionInfo(index: section))
        } else {
            return self.headerIdentifier!
        }
    }
    
    fileprivate func sectionIdentifierForFooter(section:Int) -> String
    {
        if (self.blockIdentifierForFooter != nil) {
            return self.blockIdentifierForFooter!(section, self.sectionInfo(index: section))
        } else {
            return self.footerIdentifier!
        }
    }
    
    fileprivate func viewForHeader(section:Int) -> UIView?
    {
        let header = (tableView?.dequeueReusableHeaderFooterView(withIdentifier: self.sectionIdentifierForHeader(section: section)))! as UIView
        
        if (self.blockViewForHeader != nil) {
            self.blockViewForHeader!(header, section, self.sectionInfo(index: section))
        }
        
        return header
    }
    
    fileprivate func viewForFooter(section:Int) -> UIView?
    {
        let footer = (tableView?.dequeueReusableHeaderFooterView(withIdentifier: self.sectionIdentifierForFooter(section: section)))! as UIView
        
        if (self.blockViewForFooter != nil) {
            self.blockViewForFooter!(footer, section, self.sectionInfo(index: section))
        }
        
        return footer
    }
    
    
    //MARK:-
    //MARK:- UITableView Delegate & Datasource
    
    func numberOfSections(in aTableView: UITableView) -> Int
    {
        return self.numberOfSections()
    }
    
    func tableView(_ aTableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return self.heightForHeader(section: section)
    }
    
    func tableView(_ aTableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return self.heightForFooter(section: section)
    }
    
    func tableView(_ aTableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.numberOfRows(section: section)
    }
    
    func tableView(_ aTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.heightForRow(indexPath: indexPath)
    }
    
    func tableView(_ aTableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return self.viewForHeader(section: section)
    }
    
    func tableView(_ aTableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        return self.viewForFooter(section: section)
    }
    
    func tableView(_ aTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = aTableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(indexPath: indexPath), for: indexPath)
        cell.setItem((self.item(indexPath: indexPath) as? NSManagedObject)!)
        
        if (self.blockCellForRow != nil) {
            self.blockCellForRow!(indexPath, cell, self.item(indexPath: indexPath))
        } else if (self.blockCellForRowWithSection != nil) {
            self.blockCellForRowWithSection!(indexPath, cell, self.item(indexPath: indexPath), nil, self.sectionInfo(index: indexPath.section))
        } else if (self.blockCellForItem != nil) {
            self.blockCellForItem!(indexPath, cell, self.item(indexPath: indexPath))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (self.blockDidSelectRow != nil)
        {
            self.blockDidSelectRow!(indexPath, tableView.cellForRow(at: indexPath), self.item(indexPath: indexPath))
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        if (self.blockDidDeselectRow != nil)
        {
            self.blockDidDeselectRow!(indexPath, tableView.cellForRow(at: indexPath), self.item(indexPath: indexPath))
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        var sectionIndexTitles:[String]?
        sectionIndexTitles = self.fetchedResultsController?.sectionIndexTitles
        return sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        var indexOfTitle:Int = 0
        indexOfTitle = (self.fetchedResultsController?.sectionIndexTitles.index(of: title))!
        return indexOfTitle
    }
    
    //MARK:-
    //MARK:- UICollectionView Delegate & Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return self.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.numberOfRows(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier(indexPath: indexPath), for: indexPath)
        cell.setItem(self.item(indexPath: indexPath) as! NSManagedObject)
        
        if (self.blockCellForItem != nil) {
            self.blockCellForItem!(indexPath, cell, self.item(indexPath: indexPath))
        } else if (self.blockCellForRow != nil) {
            self.blockCellForRow!(indexPath, cell, self.item(indexPath: indexPath))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if (self.blockDidSelectRow != nil) {
            self.blockDidSelectRow!(indexPath, collectionView.cellForItem(at: indexPath), self.item(indexPath: indexPath))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if (self.blockDidDeselectRow != nil) {
            self.blockDidDeselectRow!(indexPath, collectionView.cellForItem(at: indexPath), self.item(indexPath: indexPath))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return headerSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return footerSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        var view:UICollectionReusableView?
        
        if (kind == UICollectionElementKindSectionHeader)
        {
            if (headerIdentifier != nil && self.blockIdentifierForHeader != nil)
            {
                view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sectionIdentifierForHeader(section: indexPath.section), for: indexPath)
                
                if (self.blockViewForHeader != nil) {
                    self.blockViewForHeader!(view, indexPath.section, self.sectionInfo(index: indexPath.section))
                }
            }
        }
        else if (kind == UICollectionElementKindSectionFooter)
        {
            if (footerIdentifier != nil && self.blockIdentifierForFooter != nil)
            {
                view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.sectionIdentifierForFooter(section: indexPath.section), for: indexPath)
                
                if (self.blockViewForFooter != nil) {
                    self.blockViewForFooter!(view, indexPath.section, self.sectionInfo(index: indexPath.section))
                }
            }
        }
        
        return view!
    }
    
    
    
    //MARK:-
    //MARK:- NSFetchedResultsControllerDelegate
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type)
        {
        case .insert:
            self._arrInserted.add(anObject)
            break
            
        case .update:
            self._arrUpdated.add(anObject)
            break
            
        case .delete:
            self._arrDeleted.add(anObject)
            break
            
        default: break
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        self.reloadData()
        
        if (self.blockFetchResultDelegate == nil) {
            return
        }
        
        _arrInserted.removeAllObjects()
        _arrUpdated.removeAllObjects()
        _arrDeleted.removeAllObjects()
    }
}





//MARK:-
//MARK:- UIViewController(extension)

extension UIViewController
{
    func fetchController(listView:UIView, cellIdentifier:String, section:Int, rows:Int, blockCellForRow:BlockCellForRow?) -> DataSourceController
    {
        assert(!listView.isKind(of: UITableView.self) || !listView.isKind(of: UICollectionView.self), "List view must be UITableView or UICollectionView")
        
        let dataSourceController = DataSourceController(listView: listView, fetchedResultsController: nil, delegateBlock: nil, voidBlock: nil)
        
        dataSourceController.cellIdentifier = cellIdentifier
        dataSourceController.blockCellForRow = blockCellForRow
        
        dataSourceController.blockNumberOfSections = {() -> Int in
            return section
        }
        
        dataSourceController.blockNumberOfRows = {(sectionIndex, info) -> Int in
            return rows
        }
        
        return dataSourceController
    }
    
    
    func fetchController(listView:UIView, entity:String, sortDescriptors:[NSSortDescriptor]?, predicate:NSPredicate?, sectionKeyPath:String, cellIdentifier:String, batchSize:Int, blockCellForRow:BlockCellForRow?, context:NSManagedObjectContext?) -> DataSourceController
    {
        assert(!listView.isKind(of: UITableView.self) || !listView.isKind(of: UICollectionView.self), "List view must be UITableView or UICollectionView")
        
        var context = context
        if (context == nil) {
            context = CoreData.sharedInstance.mainManagedObjectContext
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchBatchSize = batchSize
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: sectionKeyPath, cacheName: nil)
        
        let dataSourceController = DataSourceController(listView: listView, fetchedResultsController: fetchResultController, delegateBlock: nil, voidBlock: nil)
        
        return dataSourceController
    }
    
    func fetchController(listView:UIView, entity:String, sortDescriptors:[NSSortDescriptor]?, predicate:NSPredicate?, sectionKeyPath:String, cellIdentifier:String, batchSize:Int, blockCellForRow:BlockCellForRow?) -> DataSourceController
    {
        assert(!listView.isKind(of: UITableView.self) || !listView.isKind(of: UICollectionView.self), "List view must be UITableView or UICollectionView")
        
        return self.fetchController(listView: listView, entity: entity, sortDescriptors: sortDescriptors, predicate: predicate, sectionKeyPath: sectionKeyPath, cellIdentifier: cellIdentifier, batchSize: batchSize, blockCellForRow: blockCellForRow, context: nil)
    }
}




//MARK:-
//MARK:- UITableViewCell(extension)

extension UITableViewCell
{
    func setItem(_ item:NSManagedObject) -> Void {
        self.set(object: item, forKey: "item")
    }
    
    func item() -> NSManagedObject? {
        return self.object(forKey: "item") as? NSManagedObject
    }
}




//MARK:-
//MARK:- UICollectionViewCell(extension)

extension UICollectionViewCell
{
    func setItem(_ item:NSManagedObject) -> Void {
        self.set(object: item, forKey: "item")
    }
    
    func item() -> NSManagedObject? {
        return self.object(forKey: "item") as? NSManagedObject
    }
}




