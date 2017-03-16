//
//  GetCalator.swift
//  checkinout
//
//  Created by Joy on 3/16/17.
//  Copyright © 2017 me. All rights reserved.
//

import Foundation

func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    let a = String(format: "%02d", seconds / 3600)
    let b = String(format: "%02d", (seconds % 3600) / 60)
    let c = String(format: "%02d",  (seconds % 3600) % 60)
    return a + ":" + b + ":" + c
}
