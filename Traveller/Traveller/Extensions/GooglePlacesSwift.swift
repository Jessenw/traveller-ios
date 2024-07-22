//
//  GooglePlacesSwift.swift
//  Traveller
//
//  Created by Jesse Williams on 22/07/2024.
//

import Foundation
import GooglePlacesSwift

extension PriceLevel {
    /// Returns the index of this PriceLevel as defined in the enum
    var caseIndex: Int? {
        PriceLevel.allCases.firstIndex(of: self)
    }
}

extension OpeningHours {
    /// Returns true if this OpeningHours is currently open
    var isOpen: Bool {
        let date = Date.now
        let dayIndex = dayOfWeekIndex(from: date)
        
        // See if there's a period whose day matches the current day
        guard let period = self.periods.first(where: { period in
            period.open.day.rawValue == dayIndex
        }) else {
            return false
        }
        
        return isTimeWithinRange(
            date: Date.now,
            startTime: (hour: Int(period.open.time.hour),
                        minute: Int(period.open.time.minute)),
            endTime: (hour:  Int(period.open.time.hour),
                      minute: Int(period.open.time.minute)))
    }
    
    func dayOfWeekIndex(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: date)
    }
}
