//
//  HWCollectionViewCell.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-16.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit

class HWCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tableView: UITableView!
    var id : Int!
    
    func setupCell(){
        WebServices.shared.refreshTableView(withScheduleId: id) { 
            self.tableView.reloadData()
        }
    }
}
extension HWCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageService.shared.calendarEntries?[id-1].count ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let calendaryEntry = StorageService.shared.calendarEntries?[id-1][indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HWCalendarVC", for: indexPath) as? HWCalendarViewCell {
            cell.setupCell(withCalendarEntry: calendaryEntry!)
        }
        return UITableViewCell()
    }
}
