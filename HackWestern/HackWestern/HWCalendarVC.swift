//
//  HWCalendarVC.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit

class HWCalendarVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension HWCalendarVC: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HWCalendarVC", for: indexPath) as? HWCalendarViewCell {
            let calendaryEntry = HWCalendarEntry(withDate: Date(), withPillName: "MDMA")
            calendaryEntry.addNewTime(time: HWOccurence(withTimeLabel: "4am", andStatus: PillStatus.CONSUMED))
            calendaryEntry.addNewTime(time: HWOccurence(withTimeLabel: "8am", andStatus: PillStatus.CONSUMED))
            calendaryEntry.addNewTime(time: HWOccurence(withTimeLabel: "10am", andStatus: PillStatus.APPROACHING))
            calendaryEntry.addNewTime(time: HWOccurence(withTimeLabel: "1pm", andStatus: PillStatus.PENDING))
            cell.setupCell(withCalendarEntry: calendaryEntry)
        }
        return UITableViewCell()
    }
}
