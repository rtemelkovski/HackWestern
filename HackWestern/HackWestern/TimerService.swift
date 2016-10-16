//
//  TimerService.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-16.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class TimerServer {
    static let shared = TimerServer()
    
    private var timer = Timer()
    
    var allowsNotification : Bool?
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer.invalidate()
    }
    @objc func update(){
        if !allowsNotification! {
            return
        }
    }
}
