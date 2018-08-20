//
//  ExtensionDate.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 31/08/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extension of Date.
extension Date {
    
    /// A Computed Property (only getter) of Double For getting the CurrentTimeStamp in Double.
    var currentTimeStamp: Double {
        return self.timeIntervalSince1970
    }
    
    /// A Computed Property (only getter) of String For getting the CurrentTimeStamp in String.
    var stringCurrentTimeStamp: String {
        return "\(self.currentTimeStamp)"
    }
    
    /// A Computed Property (only getter) of Int For getting the CurrentTimeStamp in Int.
    var intTimeStamp:Int? {
        return self.stringCurrentTimeStamp.toInt ?? nil
    }
    
}

extension Date {
    
    var day: Int {
        let component = Calendar.shared().dateComponents([.day], from: self)
        return component.day!
    }
    
    var month: Int {
        let component = Calendar.shared().dateComponents([.month], from: self)
        return component.month!
    }
    
    var year: Int {
        let component = Calendar.shared().dateComponents([.year], from: self)
        return component.year!
    }
    
    var hour: Int {
        let component = Calendar.shared().dateComponents([.hour], from: self)
        return component.hour!
    }
    
    var minute: Int {
        let component = Calendar.shared().dateComponents([.minute], from: self)
        return component.minute!
    }
    
    var second: Int {
        let component = Calendar.shared().dateComponents([.second], from: self)
        return component.second!
    }
    
    var hms: String {
        /// hh:mm:ss > 12:10:00 or 10:00
        if (self.hour > 0) {
            return String(format: "%2ld:%02ld:%02ld", self.hour, self.minute, self.second)
        } else {
            return String(format: "%02ld:%02ld", self.minute, self.second)
        }
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: self)!
    }
    
    //MARK:-
    func convertToTimezone(_ timezone:TimeZone) -> Date {
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func convertToUTC(fromTimezone timezone:TimeZone = TimeZone.current) -> Date {
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    
    //MARK:-
    func startOfDay() -> Date {
        let stringDate = DateFormatter.shared().string(fromDate: self, dateFormat: "yyyy-MM-dd") + " 00:00:00"
        let startDate = DateFormatter.shared().date(fromString: stringDate, dateFormat: "yyyy-MM-dd HH:mm:ss")
        return startDate!
    }
    
    func endOfDay() -> Date {
        let stringDate = DateFormatter.shared().string(fromDate: self, dateFormat: "yyyy-MM-dd") + " 23:59:59"
        let endDate = DateFormatter.shared().date(fromString: stringDate, dateFormat: "yyyy-MM-dd HH:mm:ss")
        return endDate!
    }
    
    func startTimestampOfDay() -> Double {
        return (self.startOfDay().currentTimeStamp)
    }
    
    func endTimestampOfDay() -> Double {
        return (self.endOfDay().currentTimeStamp)
    }
    
    
    //MARK:-
    func dateByAdd(days:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.shared().date(byAdding: dateComponents, to: self)!
    }
    
    func dateByAdd(weeks:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = 7 * weeks
        return Calendar.shared().date(byAdding: dateComponents, to: self)!
    }
    
    func dateByAdd(months:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = months
        return Calendar.shared().date(byAdding: dateComponents, to: self)!
    }
    
    func dateByAdd(years:Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = years
        return Calendar.shared().date(byAdding: dateComponents, to: self)!
    }
    
    
    
    //MARK:-
    func firstDayOfMonth() -> Date {
        let currentComponents = Calendar.shared().dateComponents([.year, .month, .day, .weekday, .weekOfMonth], from: self)
        
        var newComponents = DateComponents()
        newComponents.year          = currentComponents.year
        newComponents.month         = currentComponents.month
        newComponents.weekOfMonth   = 1
        newComponents.day           = 1
        
        return Calendar.shared().date(from: newComponents)!
    }
    
    func lastDayOfMonth() -> Date {
        let currentComponents = Calendar.shared().dateComponents([.year, .month, .day, .weekday, .weekOfMonth], from: self)
        
        var newComponents = DateComponents()
        newComponents.year          = currentComponents.year
        newComponents.month         = currentComponents.month! + 1
        newComponents.day           = 0
        
        return Calendar.shared().date(from: newComponents)!
    }
    
    
    
    //MARK:-
    func isSameDay(date:Date) -> Bool {
        let componentsA = Calendar.shared().dateComponents([.year, .month, .day], from: self)
        let componentsB = Calendar.shared().dateComponents([.year, .month, .day], from: date)
        
        return (componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day)
    }
    
    func isSameWeek(date:Date) -> Bool {
        let componentsA = Calendar.shared().dateComponents([.year, .weekOfYear], from: self)
        let componentsB = Calendar.shared().dateComponents([.year, .weekOfYear], from: date)
        
        return (componentsA.year == componentsB.year && componentsA.weekOfYear == componentsB.weekOfYear)
    }
    
    func isSameMonth(date:Date) -> Bool {
        let componentsA = Calendar.shared().dateComponents([.year, .month], from: self)
        let componentsB = Calendar.shared().dateComponents([.year, .month], from: date)
        
        return (componentsA.year == componentsB.year && componentsA.month == componentsB.month)
    }
    
    func isSameYear(date:Date) -> Bool {
        let componentsA = Calendar.shared().dateComponents([.year], from: self)
        let componentsB = Calendar.shared().dateComponents([.year], from: date)
        
        return (componentsA.year == componentsB.year)
    }
    
    func isBefore(date:Date) -> Bool {
        if (self.compare(date) == .orderedAscending) { return true }
        return false
    }
    
    func isEqualOrBefore(date:Date) -> Bool {
        if (self.isBefore(date: date) || self.isSameDay(date: date)) { return true }
        return false
    }
    
    func isAfter(date:Date) -> Bool {
        if (self.compare(date) == .orderedDescending) { return true }
        return false
    }
    
    func isEqualOrAfter(date:Date) -> Bool {
        if (self.isAfter(date: date) || self.isSameDay(date: date)) { return true }
        return false
    }
}


extension Date {
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
     
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}


//MARK:-
//MARK:- Extension - DateFormatter Singleton
extension DateFormatter {
    private static var sharedInstance: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        
//        if Localization.sharedInstance.getLanguage() == CLanguageArabic {
//            dateFormatter.locale = Locale(identifier: "ar_DZ")
//        }
//        else {
//            dateFormatter.locale = NSLocale.current
//        }
        return dateFormatter
    }()
    
    static func shared() -> DateFormatter {
        return sharedInstance
    }
    
    func string(fromDate:Date, dateFormat:String) -> String {
        self.dateFormat = dateFormat
        return self.string(from: fromDate)
    }
    
    func date(fromString:String, dateFormat:String) -> Date? {
        self.dateFormat = dateFormat
        return self.date(from: fromString)
    }
    
    func stringGMT(fromDate:Date, dateFormat: String) -> String {
        self.dateFormat = dateFormat
        DateFormatter.shared().timeZone = TimeZone(abbreviation: "GMT")
        return DateFormatter.shared().string(from: fromDate)
    }
    
    func dateGMT(fromString:String, dateFormat: String) -> Date? {
        self.dateFormat = dateFormat
        DateFormatter.shared().timeZone = TimeZone(abbreviation: "GMT")
        return DateFormatter.shared().date(from: fromString)
    }
}



//MARK:-
//MARK:- Extension - Calendor Singleton
extension Calendar {
    private static var sharedInstance: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = NSTimeZone.system
        //        calendar.locale = NSLocale.system
        return calendar
    }()
    
    static func shared() -> Calendar {
        return sharedInstance
    }
}

