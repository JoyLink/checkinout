//
//  HistoryCell.swift
//  checkinout
//
//  Created by Joy on 3/16/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    
    func configCell(dayRecord: DayRecord) {
        dateLabel.text = dayRecord.date
        hourLabel.text = secondsToHoursMinutesSeconds(seconds: Int(dayRecord.hours))
        
    }
    

}
