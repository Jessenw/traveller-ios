//
//  TripRow.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftUI

struct TripRow: View {
    var trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Trip Name
            Text(trip.name)
                .font(.headline)
            
            // Start/end dates
            if let startDate = trip.startDate, let endDate = trip.endDate {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("\(startDate, formatter: dateFormatter) - \(endDate, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            // Avatars
            let members = trip.members
            if !members.isEmpty {
                HStack(spacing: 8) {
                    ForEach(members.prefix(5), id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                    }
                    if members.count > 5 {
                        Text("+ \(members.count - 5) more")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 16)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM"
    return formatter
}()
