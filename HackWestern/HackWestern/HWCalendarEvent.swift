//
//  HWCalendarEvent.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation

class HWCalendarEvent {
    var occurance : Date!
    private var pill_missed : Int!
    private var pill_taken : Int!
    
    var pillStatus : PillStatus? {
        if pill_taken == nil || pill_missed == nil {
            return nil
        } else {
            if pill_missed == 0 && pill_taken == 0 {
                return PillStatus.PENDING
            } else if (pill_missed == 1) {
                return PillStatus.MISSED
            } else {
                return PillStatus.CONSUMED
            }
        }
    }
    func setOccurance(withOccurance occurance: Date) {
        self.occurance = occurance
    }
    func setPillMissed(withPilledMissed pillMissed: Int) {
        self.pill_missed = pillMissed
    }
    func setPillTaken(withPillTaken pillTaken : Int) {
        self.pill_taken = pillTaken
    }
}
