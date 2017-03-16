//
//  timer.swift
//  checkinout
//
//  Created by Joy on 3/15/17.
//  Copyright © 2017 me. All rights reserved.
//

import Foundation
import CoreData


class DayTimer {
    var date: String?
    var time: Int?
    
    init(date: String, time: Int) {
        self.date = date
        self.time = time
    }
    
    func save()  {
        
        let dayRecord = DayRecord(context: context)
        
        dayRecord.date = self.date
        
        dayRecord.hours = Int64(self.time!)
        
        ad.saveContext()
    }
    
}
