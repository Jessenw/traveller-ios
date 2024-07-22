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
    
    init(startDate: Date, endDate: Date) {
        self.tripDates = Date.dates(from: startDate, to: endDate)
        self._selectedDate = State(initialValue: startDate)
        
        // Mock events data
        self.events = [:]
        for date in tripDates {
            events[date] = Event.mockEvents
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            dateScrollView
            itineraryList
        }
        .navigationTitle("Trip Itinerary")
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
            LazyVStack(alignment: .leading, spacing: 20) {
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
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: event.icon)
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 20, height: 20)
                .background(alignment: .top) {
                    if event != Event.mockEvents.last {
                        Rectangle()
                            .fill(.separator)
                            .frame(width: 1, height: 65)
                    }
                }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(event.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            
//            Image("eventImage") // Replace with actual image
//                .resizable()
//                .scaledToFill()
//                .frame(width: 60, height: 60)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
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

struct TripItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        TripItineraryView(startDate: Date(), endDate: Date().addingTimeInterval(7 * 24 * 60 * 60))
    }
}
