//
//  ExtensionDateFormatter.swift
//  TheBayaApp
//
//  Created by mac-0005 on 13/09/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit

extension DateFormatter{
    
    static func dateStringFrom(timestamp: Double?, withFormate:String?) -> String {
        let fromDate:Date = Date(timeIntervalSince1970: timestamp!)
        DateFormatter.shared().locale = NSLocale.current
        
        /*
         if Localization.sharedInstance.getLanguage() == CLanguageArabic {
         DateFormatter.shared().locale = Locale(identifier: "ar_DZ")
         } else {
         DateFormatter.shared().locale = NSLocale.current
         }
         */
        return DateFormatter.shared().string(fromDate: fromDate, dateFormat: withFormate!)
    }
    
    func dateFrom(timestamp: String) -> Date? {
        let fromDate:Date = Date(timeIntervalSince1970: Double(timestamp)!)
        let stringDate = DateFormatter.shared().string(fromDate: fromDate, dateFormat: "dd MMM, YYYY")
        return DateFormatter.shared().date(fromString: stringDate, dateFormat: "dd MMM, YYYY")
    }
    
    func timestampFromDate(date : String?, formate : String?) -> Double? {
        self.dateFormat = formate
        self.timeZone = TimeZone(abbreviation: "GMT")
        var timeStamp = self.date(from: date!)?.timeIntervalSince1970
        timeStamp = Double((timeStamp?.toFloat)!)
        return timeStamp
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
