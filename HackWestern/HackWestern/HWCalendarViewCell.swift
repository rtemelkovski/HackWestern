//
//  HWCalendarViewCell.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit

class HWCalendarViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(withCalendarEntry calendarEntry : HWCalendarEntry) {
        resetCell()
        if let dateLbl = self.viewWithTag(1) as? UILabel {
            dateLbl.text = DateService.shared.getStringFromNSDate(withNSDate: calendarEntry.date)
        }
        if let pillnameLbl = self.viewWithTag(2) as? UILabel {
            pillnameLbl.text = calendarEntry.pillName
        }
        var offset = 3
        for occurence in calendarEntry.occurences {
            if let newTime = self.viewWithTag(offset) as? UIButton {
                newTime.setTitle(occurence.time, for: .normal)
                newTime.isHidden = false
                configureButtonColorWithOccurence(button: newTime, occurence: occurence)
                offset = offset + 1
            }
        }
    }
    private func configureButtonColorWithOccurence(button : UIButton, occurence : HWOccurence) {
        if occurence.status == PillStatus.CONSUMED {
            button.backgroundColor = UIColor.consumed
        } else if (occurence.status == PillStatus.MISSED){
            button.backgroundColor = UIColor.missed
        } else if (occurence.status == PillStatus.APPROACHING) {
            button.backgroundColor = UIColor.approaching
        } else {
            button.backgroundColor = UIColor.pending
        }
    }
    private func resetCell(){
        for i in 3..<8 {
            if let newTime = self.viewWithTag(i) as? UIButton {
                newTime.isHidden = true
            }
        }
    }
}
