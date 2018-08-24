//
//  ExtensionUITextView.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 25/08/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

// TODO :- Delegate Issue

// MARK: - Extension of UITextView For UITextView's placeholder Text and For  UITextView's placeholderColor
extension UITextView : UITextViewDelegate {
    
    /// Placeholder Text of UITextView , as it is @IBInspectable so you can directlly set placeholder Text of UITextView From Interface Builder , No need to write any number of Lines.
    @IBInspectable var placeholder:String? {
        
        get  {
            
            var placeholderLabelText:String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabelText = placeholderLabel.text
            }
            
            return placeholderLabelText
        } set {
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
            } else {
                
                self.addPlaceholderLabel(placeholder: newValue, placeholderColor: nil, placeholderFont: nil)
            }
        }
    }
    
     var placeholderFont:UIFont? {
        
        get  {
            
            var placeholderLabelFont:UIFont?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabelFont = placeholderLabel.font
            }
            
            return placeholderLabelFont
        } set {
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.font = newValue
            } else {
                
                self.addPlaceholderLabel(placeholder: placeholder, placeholderColor: placeholderColor, placeholderFont: newValue)
            }
        }
    }
    
    /// Placeholder Color of UITextView , as it is @IBInspectable so you can directlly set placeholder Color of UITextView From Interface Builder , No need to write any number of Lines.
    @IBInspectable var placeholderColor:UIColor? {
        
        get  {
            
            var placeholdeLabelTextColor:UIColor?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholdeLabelTextColor = placeholderLabel.textColor
            }
            
            return placeholdeLabelTextColor
        } set {
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.textColor = newValue
            } else {
                
                self.addPlaceholderLabel(placeholder: placeholder, placeholderColor: newValue, placeholderFont: self.font)
           }
        }
    }
    
    /// This Private Method is used to Add placeholderLabel in UITextView.
    ///
    /// - Parameters:
    ///   - placeholder: A String Value that indicates the placeholder Text of UITextView.
    ///   - placeholderColor: A UIColor Value that indicates the placeholder Color of UITextView.
    private func addPlaceholderLabel(placeholder:String? , placeholderColor:UIColor? , placeholderFont:UIFont?) {
        
        let placeholderLabel = UILabel()
        
//        if Localization.sharedInstance.getLanguage() == CLanguageArabic {
//            placeholderLabel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        }
        
        placeholderLabel.textAlignment = self.textAlignment
        print(self.textAlignment.rawValue)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.tag = 100
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.font = placeholderFont
        placeholderLabel.sizeToFit()
        placeholderLabel.isHidden = self.text.count > 0
        self.addSubview(placeholderLabel)
        
        self.resizePlaceholderLabel()
        self.delegate = self
        
        self.addObserver(self, forKeyPath: "text", options: .new, context: nil)
    }
    
    /// This Private Method is used to Assign Frame to placeholderLabel in UITextView.
    public func resizePlaceholderLabel() {
        
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top
            
            placeholderLabel.frame = CGRect(x: 4.0, y: labelY, width: (CScreenWidth - (4 * labelX) - 5), height: placeholderLabel.frame.size.height)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        
        if newSuperview == nil {
            if (self.viewWithTag(100) as? UILabel) != nil {
                self.removeObserver(self, forKeyPath: "text")
            }
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "text" {
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.isHidden = self.text.count > 0
            }
        }
    }
    
}
