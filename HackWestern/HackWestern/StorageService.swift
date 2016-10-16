//
//  StorageService.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation

class StorageService {
    static let shared = StorageService()
    
    var calendarEntry : [HWCalendarEntry]?
    var calendarEntries : [[HWCalendarEntry]]?
    var scheduleIndexs = [Int]() {
        didSet {
            calendarEntries = [[HWCalendarEntry]]()
            for _ in 0..<scheduleIndexs.count {
                calendarEntries?.append([HWCalendarEntry]())
            }
        }
    }
    
}
