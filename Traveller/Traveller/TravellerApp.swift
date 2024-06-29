//
//  TravellerApp.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import GoogleMaps
import SwiftUI
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        GMSServices.provideAPIKey(Configuration.GMSServicesAPIKey)
    }
}

@main
struct TravellerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Trip.self,
            Task.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
