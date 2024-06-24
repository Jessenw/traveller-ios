//
//  TravellerApp.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftUI
import SwiftData

@main
struct TravellerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Trip.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
