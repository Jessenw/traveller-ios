//
//  TripRow.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftUI

struct TripRow: View {
    let trip: Trip
    
    var body: some View {
        NavigationLink(destination: TripDetailContainer(trip: trip)) {
            VStack(alignment: .leading, spacing: 8) {
                // Trip name
                Text(trip.name)
                    .font(.headline)
                
                // Start/end dates
                if let startDate = trip.startDate, let endDate = trip.endDate {
                    TripDatesView(from: startDate, to: endDate)
                }
                
                // Avatars
                AvatarsView(members: trip.members)
            }
        }
    }
}
