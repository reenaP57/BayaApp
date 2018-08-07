//
//  ExtensionArray.swift
//  Cam4Sell
//
//  Created by Mac-00014 on 01/12/17.
//  Copyright © 2017 Mac-00014. All rights reserved.
//

import Foundation
//MARK:-
//MARK:- Extension -
extension Array
{
    func mapValue(forKey:String) -> AnyObject
    {
        if let array = self as? Array<[String:AnyObject]>
        {
            return array.map({$0[forKey]! as AnyObject}) as AnyObject
        }
        return Array() as AnyObject
    }
    func filterValue(key:String, value:String, getValueForKey:String) -> AnyObject
    {
        
        if let array = self as? Array<[String:AnyObject]>
        {
            var object =  array.filter({
                $0[key] as! String ==  value }).first
           
            guard let objectValue = object![getValueForKey] else
            {
                return "" as AnyObject
            }
            
            return objectValue
                        
        }
        return "" as AnyObject
        
    }
    
    
}
