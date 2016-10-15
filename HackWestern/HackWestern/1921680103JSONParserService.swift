//
//  1921680103JSONParserService.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class ServerSideParserService {
    static let shared = ServerSideParserService()

    public func getCalendarEntrys(fromResponse response : DataResponse<Any>) -> [HWCalendarEntry]{
        if let value = response.result.value as? [String : AnyObject] {
            if let events = value["events"] as? [AnyObject]{
                for event in events{
                    
                }
            }
        }
        return [HWCalendarEntry]()
    }
}
