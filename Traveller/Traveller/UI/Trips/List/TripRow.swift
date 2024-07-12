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
        //NavigationLink(destination: TripDetail(trip: trip)) {
            HStack {
                VStack(alignment: .leading) {
                    // Trip name
                    Text(trip.name)
                        .font(.headline)
                    
                    HStack(alignment: .center) {
                        // Start/end dates
                        if let startDate = trip.startDate, let endDate = trip.endDate {
                            Group {
                                TripDatesView(startDate: startDate, endDate: endDate)
                                Text("•")
                            }
                            // .foregroundColor(.secondary)
                        }
                        
                        // Avatars
                        AvatarsView(members: trip.members)
                    }
                }
                Spacer()
            }
        //}
    }
}

#Preview {
    Group {
        TripRow(trip: Trip(
            name: "Trip to Taiwan"
        ))
        TripRow(trip: Trip(
            name: "Trip to South Korea",
            startDate: Date.now,
            endDate: Date.distantFuture
        ))
    }
}
