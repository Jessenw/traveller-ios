//
//  TripDetailView.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import SwiftUI
import Combine
import GooglePlacesSwift
import GoogleMaps

enum SheetScreen: String, CaseIterable, Identifiable {
    case places
    case todos
    
    var id: SheetScreen.RawValue { rawValue }
    
    var title: String {
        switch self {
        case .places:
            "Places"
        case .todos:
            "Todos"
        }
    }
}

struct TripDetailView: View {
    // Properties
    @ObservedObject private var placesService = PlacesService.shared
    
    let trip: Trip
    
    // State
    @State private var selectedSheetScreen: SheetScreen = .places
    
    // Constants
    private let availableDetents: Set<PresentationDetent> = [.fraction(1/4), .medium, .large]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TripItineraryView(
                trip: trip,
                startDate: trip.startDate ?? .now,
                endDate: trip.endDate ?? .now)
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                VStack {
                    Picker("Select screen", selection: $selectedSheetScreen) {
                        ForEach(SheetScreen.allCases) { screen in
                            Text(screen.title).tag(screen)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding([.top, .horizontal])
                    
                    if selectedSheetScreen == .places {
                        PlaceList(trip: trip)
                    } else if selectedSheetScreen == .todos {
                        TodoListView(tripId: trip.persistentModelID)
                    }
                }
            }
            .presentationDetents(availableDetents)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
    }
}
