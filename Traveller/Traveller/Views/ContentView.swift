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

    var body: some View {
        TripListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
