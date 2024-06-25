//
//  TripDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TripDetail: View {
    var trip: Trip
    @State private var isShowingSheet = true
    
    var body: some View {
        MapContainerView()
            .sheet(isPresented: $isShowingSheet) {
                TripDetailSheet(trip: trip)
                    .presentationDetents([.medium, .large])
                    .interactiveDismissDisabled()
            }
    }
}

struct TripDetailSheet: View {
    var trip: Trip
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        // Trip name
                        Text(trip.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Trip detail
                        if let detail = trip.detail {
                            Text(detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        
                        // Trip dates
                        HStack {
                            if let startDate = trip.startDate, let endDate = trip.endDate {
                                HStack {
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text("\(Utilities.formattedDate(startDate)) - \(Utilities.formattedDate(endDate))")
                                        .font(.caption)
                                    Text("•")
                                }
                                .foregroundStyle(.secondary)
                            }
                            
                            // Member avatars
                            HStack(spacing: 4) {
                                ForEach(trip.members, id: \.self) { member in
                                    Circle()
                                        .fill(Utilities.randomColor())
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    Spacer()
                }
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    TripDetail(
        trip: Trip(
            name: "My cool adventure",
            detail: "Where are we going?",
            startDate: Date.distantPast,
            endDate: Date.now,
            members: ["", ""],
            places: [],
            tasks: []))
}
