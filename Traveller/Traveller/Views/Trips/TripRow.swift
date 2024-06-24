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
                .padding(.top, 8)
            
            // Start/end dates
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                if let startDate = trip.startDate, let endDate = trip.endDate {
                    Text("\(startDate, formatter: dateFormatter) - \(endDate, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 16)
            
            // Avatars
            let members = trip.members
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
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM"
    return formatter
}()
