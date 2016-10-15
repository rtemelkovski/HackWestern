//
//  HWDate.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation

class HWCalendarEntry {
    var date : Date!
    var pillName : String!
    var occurences = [HWOccurence]()
    init(withDate date : Date, withPillName pillName : String){
        self.date = date
        self.pillName = pillName
    }
    public func addNewTime(time : HWOccurence) {
        occurences.append(time)
    }
}
