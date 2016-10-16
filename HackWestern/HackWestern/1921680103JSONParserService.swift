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

    public func getCalendarEntrys(fromResponse response : DataResponse<Any>, completion : @escaping (_ calendarEntry : [HWCalendarEntry]) -> Void){
        var returnCalendarEntry = [HWCalendarEntry]()
        print(response.description)
        var previousDate = Date.init(timeIntervalSince1970: 0)
        var id : Int!
        if let value = response.result.value as? [String : AnyObject] {
            if let events = value["events"] as? [AnyObject]{
                for event in events{
                    let calendarEvent = HWCalendarEvent()
                    if let occurence = event["occurance"] as? String {
                        let splitDate = occurence.components(separatedBy: "T")
                        calendarEvent.day = DateService.shared.getDayFromServerString(string: splitDate[0])
                        calendarEvent.time = String(splitDate[1].characters.prefix(5))
                    }
                    if let id2 = event["schedule_id"] as? Int {
                        id = id2
                    }
                    if let pillMissed = event["pill_missed"] as? Int {
                        calendarEvent.setPillMissed(withPilledMissed: pillMissed)
                    }
                    if let pillTaken = event["pill_taken"] as? Int {
                        calendarEvent.setPillTaken(withPillTaken: pillTaken)
                    }
                    
                    if calendarEvent.day.timeIntervalSince(previousDate).isZero {
                        //Merge the days...
                        returnCalendarEntry.last?.addNewTime(time: HWOccurence(withTimeLabel: calendarEvent.time, andStatus: calendarEvent.pillStatus!))
                        previousDate = calendarEvent.day
                    } else {
                        //Add new day.
                        let calendarEntry = HWCalendarEntry(withDate: calendarEvent.day, withPillName: "Advil")
                        calendarEntry.addNewTime(time: HWOccurence(withTimeLabel: calendarEvent.time, andStatus: calendarEvent.pillStatus!))
                        returnCalendarEntry.append(calendarEntry)
                        previousDate = calendarEvent.day
                    }
                }
            }
        }
        if ((id) != nil) {
            WebServices.shared.getSchedule(withID: id) { (pillName) in
                for entry in returnCalendarEntry {
                    entry.pillName = pillName
                }
                StorageService.shared.calendarEntry = returnCalendarEntry
                completion(returnCalendarEntry)
            }
        }
    }
}
