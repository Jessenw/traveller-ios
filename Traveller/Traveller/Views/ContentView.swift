//
//  ContentView.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    private let trips: [Trip] = [
        Trip(
            name: "Grace and Jesse's Dumpling Adventure",
            startDate: Date.distantPast,
            endDate: Date.now,
            members: [.blue, .gray, .orange],
            places: ["korea", "Taiwan"],
            tasks: ["Book flights"]),
        Trip(
            name: "Grace and Jesse's Auckland Adventure",
            startDate: Date.now,
            endDate: Date.distantFuture,
            members: [.green, .gray, .purple],
            places: ["Sue's Dumplings", "MIZU"],
            tasks: ["Find accomodation"])
    ]

    var body: some View {
        TripListView(trips: trips)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
