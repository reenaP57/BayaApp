//
//  ExtensionUIButton.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 01/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

typealias genericTouchUpInsideHandler<T> = ((T) -> ())

// MARK: - Extension of UIButton For TouchUpInside Handler.
extension UIButton {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        static var genericTouchUpInsideHandler = "genericTouchUpInsideHandler"
    }
    
    /// This method is used for UIButton's touchUpInside Handler
    ///
    /// - Parameter genericTouchUpInsideHandler: genericTouchUpInsideHandler will give you object of UIButton.
    func touchUpInside(genericTouchUpInsideHandler:@escaping genericTouchUpInsideHandler<UIButton>) {
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.genericTouchUpInsideHandler, genericTouchUpInsideHandler, .OBJC_ASSOCIATION_RETAIN)
        
        self.addTarget(self, action: #selector(handleButtonTouchEvent(sender:)), for: .touchUpInside)
    }
    
    /// This Private method is used for handle the touch event of UIButton.
    ///
    /// - Parameter sender: UIButton.
    @objc private func handleButtonTouchEvent(sender:UIButton) {
        
        if let genericTouchUpInsideHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.genericTouchUpInsideHandler) as?  genericTouchUpInsideHandler<UIButton> {
            
            genericTouchUpInsideHandler(sender)
        }
    }
    
}

// MARK: - Extension of UIButton For getting the IndexPath of UIButton that's exist on UITableView.
extension UIButton {
    
    /// This method is used For getting the IndexPath of UIButton that's exist on UITableView.
    ///
    /// - Parameter tableView: A UITableView.
    /// - Returns: This Method returns IndexPath? , it means this method return nil value also , while using this method please use if let. If you are not using if let and if this method returns nil and when you are trying to unwrapped this value("IndexPath!") then application will crash.
    func toIndexPath(tableView:UITableView) -> IndexPath? {
        
        let point = self.convert(CGPoint.zero, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: point) {
            
            return indexPath
        } else { return nil }
    }
}


extension UIButton {
    
    func setNormalTitle(normalTitle:String?) {
        self.setTitle(normalTitle, for: .normal)
    }
    
    func setSelectedTitle(selectedTitle:String?) {
        self.setTitle(selectedTitle, for: .selected)
    }
    
    func setHighLightedTitle(highLightedTitle:String?) {
        self.setTitle(highLightedTitle, for: .highlighted)
    }
    
    func setTitles(normalTitle:String? , selectedTitle:String? , highLightedTitle:String?) {
        self.setNormalTitle(normalTitle: normalTitle)
        self.setSelectedTitle(selectedTitle: selectedTitle)
        self.setHighLightedTitle(highLightedTitle: highLightedTitle)
    }
    
    func setTitles(normalTitle:String? , selectedTitle:String?) {
        self.setNormalTitle(normalTitle: normalTitle)
        self.setSelectedTitle(selectedTitle: selectedTitle)
    }
}

extension UIButton {
    
    func setNormalImage(normalImgName:String) {
        self.setImage(UIImage(named: normalImgName), for: .normal)
    }
    
    func setSelectedImage(selectedImgName:String) {
        self.setImage(UIImage(named: selectedImgName), for: .selected)
    }
    
    func setHighLightedImage(highLightedImgName:String) {
        self.setImage(UIImage(named: highLightedImgName), for: .highlighted)
    }
    
    func setImages(normalImgName:String , selectedImgName:String , highLightedImgName:String) {
        
        self.setNormalImage(normalImgName: normalImgName)
        self.setSelectedImage(selectedImgName: selectedImgName)
        self.setHighLightedImage(highLightedImgName: highLightedImgName)
    }
    
    func setImages(normalImgName:String , selectedImgName:String) {
        self.setNormalImage(normalImgName: normalImgName)
        self.setSelectedImage(selectedImgName: selectedImgName)
    }
}

extension UIButton {
    
    func setNormalTitleColor(color:UIColor?) {
        self.setTitleColor(color, for: .normal)
    }
    
    func setSelectedTitleColor(color:UIColor?) {
        self.setTitleColor(color, for: .selected)
    }
    
    func setHighLightedTitleColor(color:UIColor?) {
        self.setTitleColor(color, for: .highlighted)
    }
    
    func setTitleColors(normalColor:UIColor? , selectedColor:UIColor? , highLightedColor:UIColor?) {
        
        self.setNormalTitleColor(color: normalColor)
        self.setSelectedTitleColor(color: selectedColor)
        self.setHighLightedTitleColor(color: highLightedColor)
    }
    
    func setTitleColors(normalColor:UIColor? , selectedColor:UIColor?) {
        self.setNormalTitleColor(color: normalColor)
        self.setSelectedTitleColor(color: selectedColor)
    }
    
}


