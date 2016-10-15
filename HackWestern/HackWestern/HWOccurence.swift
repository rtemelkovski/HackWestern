//
//  HWOccurence.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation

class HWOccurence {
    var time : String!
    var status : PillStatus
    
    init(withTimeLabel time : String, andStatus status : PillStatus) {
        self.time = time
        self.status = status
    }
}
