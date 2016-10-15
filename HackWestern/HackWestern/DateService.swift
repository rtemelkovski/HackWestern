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

}
