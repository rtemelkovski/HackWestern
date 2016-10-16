//
//  DateService.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation

class DateService {
    static let shared = DateService()
    
    public func getStringFromNSDate(withNSDate date : Date) -> String{
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("EEEE,  MMM d, yyyy")
        return format.string(from: date)
    }

    public func getDateFromStringWithDayPrecise(dateString : String) -> Date {
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        return format.date(from: dateString)!
    }
    
    public func getTime(fromDate date : Date) -> String{
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        return "\(comp.hour):\(comp.minute)"
    }
    
    public func getDayFromServerString(string : String) -> Date {
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        return format.date(from: string)!
    }

    public func getTimeFromServerString(string : String) -> Date {
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        return format.date(from: string)!
    }
    public func printDate(date : Date){
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        print(comp.day)
        print(comp.month)
        print(comp.year)
        print(comp.hour)
        print(comp.minute)
    }
    public func getDay(fromDate date : Date) -> Date {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.day, .month, .year], from: date)
        let format = DateFormatter()
        format.setLocalizedDateFormatFromTemplate("MM/dd/yyyy")
        let dateString = "\(comp.month)/\(comp.day)/\(comp.year)"
        return format.date(from: dateString)!
    }
}
