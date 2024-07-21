//
//  CalendarScreen.swift
//  Traveller
//
//  Created by Jesse Williams on 19/07/2024.
//

import MijickCalendarView
import SwiftUI

struct CalendarScreen: View {
    @State private var selectedDate: Date? = Date.now
    @State private var selectedRange: MDateRange? = .init()
    
    var trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
        
        if let startDate = trip.startDate, let endDate = trip.endDate {
            selectedRange = MDateRange(startDate: startDate, endDate: endDate)
        }
    }
    
    var body: some View {
        MCalendarView(
            selectedDate: $selectedDate,
            selectedRange: $selectedRange,
            configBuilder: configureCalendar)
    }
    
    private func configureCalendar(_ config: CalendarConfig) -> CalendarConfig {
        config
            .daysHorizontalSpacing(9)
            .daysVerticalSpacing(19)
            .monthsBottomPadding(16)
            .monthsTopPadding(42)
    }
}
