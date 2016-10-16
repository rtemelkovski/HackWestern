//
//  HWCalendarVC.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit

class HWCalendarVC: UIViewController {

    @IBOutlet weak var calendarTableView: UITableView!
    
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh!")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        calendarTableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarTableView.reloadData()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func refresh (sender: AnyObject){
        WebServices.shared.refreshTableView(withScheduleId: 1) { 
            self.calendarTableView.reloadData()
            self.stopRefresher()
        }
    }
    func stopRefresher()
    {
        refreshControl.endRefreshing()
    }
}

extension HWCalendarVC: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return StorageService.shared.calendarEntry?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let calendaryEntry = StorageService.shared.calendarEntry?[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HWCalendarVC", for: indexPath) as? HWCalendarViewCell {
            cell.setupCell(withCalendarEntry: calendaryEntry!)
        }
        return UITableViewCell()
    }
}
