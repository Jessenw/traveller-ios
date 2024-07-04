//
//  TripDatesView.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import SwiftUI

struct TripDatesView: View {
    let startDate: Date
    let endDate: Date
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
            Text("\(startDate.formatted) - \(endDate.formatted)")
        }
        .font(.caption)
    }
}

#Preview {
    TripDatesView(
        startDate: Date.now,
        endDate: Date.distantFuture
    )
}
