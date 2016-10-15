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
            print(response.description)
            if let value = response.result.value as? [String : AnyObject] {
                if let result = value["result"] as? [String : AnyObject] {
                    if let fulfillment = result["fulfillment"] as? [String : AnyObject] {
                        if let speech = fulfillment["speech"] as? String  , speech != "" {
                            completion(nil, speech)
                            return
                        }
                    }
                }
            }
        }
    }
    
    public func sendResponseToServer(){
        let url = "http://some.url"
        
        let parameters: Parameters = [
            "foo": [1,2,3],
            "bar": [
                "baz": "qux"
            ]
        ]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            //parse the response
        }
    }
}
