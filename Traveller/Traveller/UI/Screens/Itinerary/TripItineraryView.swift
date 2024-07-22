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
    var events: [Date: [Event]]
    
    var trip: Trip
    
    init(trip: Trip, startDate: Date, endDate: Date) {
        self.trip = trip
        self.tripDates = Date.dates(from: startDate, to: endDate)
        self._selectedDate = State(initialValue: startDate)
        
        let tripEvents = trip.places.map { place in
            Event(title: place.name, subtitle: place.subtitle, icon: "bed.double.circle.fill")
        }
        
        self.events = [:]
        for date in tripDates {
            events[date] = tripEvents
        }
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
                ForEach(events[selectedDate] ?? [], id: \.title) { event in
                    EventRow(event: event)
                }
            }
            .padding()
        }
    }
}

struct EventRow: View {
    let event: Event
    let iconSize: CGFloat = 20
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: event.icon)
                .resizable()
                .foregroundColor(.blue)
                .frame(width: iconSize, height: iconSize)
            
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(event.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            
            Image("eventImage") // Replace with actual image
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .background() {
            GeometryReader { geometry in
                if event != Event.mockEvents.last {
                    Rectangle()
                        .fill(.separator)
                        .position(
                            x: iconSize / 2,
                            y: geometry.size.height - iconSize)
                        .frame(width: 1, height: geometry.size.height - iconSize)
                }
            }
        }
    }
}

struct Event: Equatable {
    let title: String
    let subtitle: String
    let icon: String
    
    static let mockEvents = [
        Event(title: "Check-in", subtitle: "Hotel ABC", icon: "bed.double.circle.fill"),
        Event(title: "City Tour", subtitle: "Downtown", icon: "map.circle.fill"),
        Event(title: "Dinner", subtitle: "Restaurant XYZ", icon: "fork.knife.circle.fill")
    ]
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
