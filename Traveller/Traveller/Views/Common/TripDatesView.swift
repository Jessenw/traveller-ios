//
//  TripDatesView.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import SwiftUI

struct TripDatesView: View {
    private let startDate: Date
    private let endDate: Date
    
    init(from startDate: Date, to endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
            Text("\(startDate.formatted) - \(endDate.formatted)")
                .font(.subheadline)
        }
        .foregroundColor(.secondary)
    }
}

#Preview {
    TripDatesView(from: Date.now, to: Date.distantFuture)
}
