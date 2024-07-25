//
//  TripItineraryView.swift
//  Traveller
//
//  Created by Jesse Williams on 22/07/2024.
//

import SwiftUI

struct TripItineraryView: View {
    @State private var selectedDate: Date
    let tripDates: [Date]
    var places: [Place]
    
    var trip: Trip
    
    init(trip: Trip, startDate: Date, endDate: Date) {
        self.trip = trip
        self.tripDates = Date.dates(from: startDate, to: endDate)
        self._selectedDate = State(initialValue: startDate)
        self.places = trip.places
    }
    
    var body: some View {
        VStack(spacing: 0) {
            dateScrollView
            itineraryList
        }
    }
    
    var dateScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center,spacing: 10) {
                Spacer()
                ForEach(tripDates, id: \.self) { date in
                    dateButton(for: date)
                }
                Spacer()
            }
            .padding()
        }
    }
    
    func dateButton(for date: Date) -> some View {
        Button(action: {
            selectedDate = date
        }) {
            VStack {
                Text(date.formatted(.dateTime.day()))
                    .font(.headline)
                Text(date.formatted(.dateTime.month(.abbreviated)))
                    .font(.subheadline)
            }
            .padding(8)
            .background(selectedDate == date ? .blue : .clear)
            .foregroundColor(selectedDate == date ? .white : .primary)
            .cornerRadius(8)
        }
    }
    
    var itineraryList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(places) { place in
                    PlaceRow(
                        place: place,
                        showSeparators: true,
                        isLast: true)
                }
            }
            .padding()
        }
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        return dates
    }
}
