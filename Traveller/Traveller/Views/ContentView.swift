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

    var body: some View {
        TripListView()
    }
}

#Preview {
    ContentView()
}
