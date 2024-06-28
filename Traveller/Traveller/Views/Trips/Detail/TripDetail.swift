//
//  TripDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TripDetail: View {
    @State private var isShowingSheet = true
    
    var trip: Trip
    
    var body: some View {
        MapContainerView()
            .sheet(isPresented: $isShowingSheet) {
                TripDetailSheet(trip: trip)
                    .presentationDetents([.fraction(1/3), .fraction(0.999)])
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
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
