//
//  ExtensionString.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 01/09/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation

// MARK: - Extension of String For Converting it TO Int AND URL.
extension String {
    
    /// A Computed Property (only getter) of Int For getting the Int? value from String.
    /// This Computed Property (only getter) returns Int? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("Int!") then application will crash.
    var toInt:Int? {
        return Int(self)
    }
    
    var toDouble:Double? {
        return Double(self)
    }
    
    var toFloat:Float? {
        return Float(self)
    }
    
    
    /// A Computed Property (only getter) of URL For getting the URL from String.
    /// This Computed Property (only getter) returns URL? , it means this Computed Property (only getter) return nil value also , while using this Computed Property (only getter) please use if let. If you are not using if let and if this Computed Property (only getter) returns nil and when you are trying to unwrapped this value("URL!") then application will crash.
    var toURL:URL? {
        return URL(string: self)
    }
    
}

extension String {
    
    var trim:String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    var isBlank:Bool {
        return self.trim.isEmpty
    }
    
    var isNumber : Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isAlphanumeric:Bool {
      return !isBlank && rangeOfCharacter(from: .alphanumerics) != nil
    }
    
    var isValidEmail:Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with:self)
    }
    
//    var isValidPassword:Bool {
//
//        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$"
//        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
//        return predicate.evaluate(with:self)
//    }
    
    var isValidPassword:Bool {
        
        let passwordCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%").inverted
        let arrCharacters = self.components(separatedBy: passwordCharacters)
        return self == arrCharacters.joined(separator: "")
    }
    
    var isValidPhoneNo:Bool {
        
        let phoneCharacters = CharacterSet(charactersIn: "+0123456789").inverted
        let arrCharacters = self.components(separatedBy: phoneCharacters)
        return self == arrCharacters.joined(separator: "")
    }
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: String.Encoding.unicode) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
 
    static func dateStringFrom(timestamp: String, withFormate:String) -> String {
        let fromDate:Date = Date(timeIntervalSince1970: Double(timestamp)!)
        DateFormatter.shared().locale = NSLocale.current
       
        /*
        if Localization.sharedInstance.getLanguage() == CLanguageArabic {
            DateFormatter.shared().locale = Locale(identifier: "ar_DZ")
        } else {
            DateFormatter.shared().locale = NSLocale.current
        }
        */
        return DateFormatter.shared().string(fromDate: fromDate, dateFormat: withFormate)
    }
    
    func dateFrom(timestamp: String) -> Date? {
        let fromDate:Date = Date(timeIntervalSince1970: Double(timestamp)!)
        let stringDate = DateFormatter.shared().string(fromDate: fromDate, dateFormat: "dd MMM, YYYY")
        return DateFormatter.shared().date(fromString: stringDate, dateFormat: "dd MMM, YYYY")
    }
    
    func durationString(duration: String) -> String
    {
        let calender:Calendar = Calendar.current as Calendar
        let fromDate:Date = Date(timeIntervalSince1970: Double(duration)!)
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute])
        let dateComponents = calender.dateComponents(unitFlags, from:fromDate , to: Date())
        
        let years:NSInteger = dateComponents.year!
        let months:NSInteger = dateComponents.month!
        let days:NSInteger = dateComponents.day!
        let hours:NSInteger = dateComponents.hour!
        let minutes:NSInteger = dateComponents.minute!
        
//        print(calender.date(from: dateComponents)!)
        print(DateFormatter.shared().string(fromDate: DateFormatter.shared().dateGMT(fromString: DateFormatter.shared().stringGMT(fromDate: calender.date(from: dateComponents)!, dateFormat: "dd MMM, HH:mm"), dateFormat: "dd MMM, HH:mm")!, dateFormat: "dd MMM, HH:mm"))
        
        return DateFormatter.shared().string(fromDate: DateFormatter.shared().date(fromString: DateFormatter.shared().stringGMT(fromDate: calender.date(from: dateComponents)!, dateFormat: "dd MMM, hh:mm a"), dateFormat: "dd MMM, hh:mm a")!, dateFormat: "dd MMM, hh:mm a")
        
//        return DateFormatter.shared().stringGMT(fromDate: calender.date(from: dateComponents)!, dateFormat: "dd MMM, hh:mm a")
        
        var durations:NSString = "Just Now"
        
        if (years > 0) {
            durations = "\(years) years ago" as NSString
        }
        else if (months > 0) {
            durations = "\(months) months ago" as NSString
        }
        else if (days > 0) {
            durations = "\(days) days ago" as NSString
        }
        else if (hours > 0) {
            durations = "\(hours) hours ago" as NSString
        }
        else if (minutes > 0) {
            durations = "\(minutes) mins ago" as NSString
        }
        
        return durations as String;
    }
    
}

extension StringProtocol where Index == String.Index {
    func nsRange(of string: String) -> NSRange {
        if let range = self.range(of: string) {
            return NSRange(range, in: self)
        }
        return NSMakeRange(0, 0)
    }
}
