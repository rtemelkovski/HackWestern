//
//  WebServices.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class WebServices {
    static let shared = WebServices()

    public func getResponseFromServer(query : String, completion : @escaping (_ response : DataResponse<Any>?, _ error : String?) -> Void) {
    
        var startDate : String?
        var endDate : String?
        var name : String?
        var time = [String!]()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer ab2748e73233407980ac35ba450c21e3",
            "Content-Type" : "application/json",
            ]
        let url = URL(string: "https://api.api.ai/v1/query?v=20150910")
        let parameters: Parameters = [
            "query": "\(query)",
            "lang": "en",
            ]
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            completion(response, nil)
            //print(response.description)
            if let value = response.result.value as? [String : AnyObject] {
                if let result = value["result"] as? [String : AnyObject] {
                    if let fulfillment = result["fulfillment"] as? [String : AnyObject] {
                        if let speech = fulfillment["speech"] as? String  , speech != "" {
                            completion(nil, speech)
                            return
                        }
                    }
                    if let params = result["parameters"] as? [String : AnyObject] {
                        if let sdate = params["date"] as? String {
                            startDate = sdate
                            if DateService.shared.getDateFromStringWithDayPrecise(dateString: startDate!).timeIntervalSinceNow.isLess(than: 0){
                                completion(nil, "The start date is before today's date!")
                                return
                            }
                        }
                        if let edate = params["date1"] as? String {
                            endDate = edate
                            let afterDate = DateService.shared.getDateFromStringWithDayPrecise(dateString: endDate!)
                            let initialDate = DateService.shared.getDateFromStringWithDayPrecise(dateString: startDate!)
                            if afterDate.timeIntervalSince(initialDate).isLess(than: 0) {
                                completion(nil, "The end date is before the start date!")
                                return
                            }
                        }
                        if let pill = params["pill"] as? String {
                            name = pill.replacingOccurrences(of: "@", with: "")
                        }
                        if let times = params["time"] as? [String] {
                            for t in times {
                                time.append(t)
                            }
                        }
                    }
                }
            }
            let newParams : Parameters = [
                "start" : "\(startDate!)",
                "end" : "\(endDate!)",
                "name" : "\(name!)",
                "time" : time
            ]
            self.sendResponseToServer(withParams: newParams)
        }
    }
    
    public func sendResponseToServer(withParams parameters : Parameters){
        let url = URL(string :"http://192.168.0.103:5000/api/schedules")
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.description)
            ServerSideParserService.shared.getCalendarEntrys(fromResponse: response)
        }
    }
    public func deleteMe(){
        let url = URL(string :"http://192.168.0.103:5000/api/schedules")
        
        let headers = [
            "Content-Type": "application/json"
        ]
        let parameters : Parameters = [
            "start" : "2016-11-06",
            "end" : "2016-11-08",
            "name" : "Meth",
            "time" : ["08:00:00", "10:00:00"]
        ]
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.description)
            ServerSideParserService.shared.getCalendarEntrys(fromResponse: response)
        }
    }
    public func refreshTableView(withScheduleId id : Int){
        let url = URL(string: "http://192.168.0.103:5000/api/schedules/\(id)")
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = ["action": "all"]
        
        Alamofire.request(url!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            print(response.description)
        }
    }
}
