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

enum SheetScreen: Equatable {
    case places
    case todos
}

struct TripDetailView: View {
    // Properties
    @ObservedObject private var placesService = PlacesService.shared
    
    let trip: Trip
    
    // State
    @State private var selectedDetent: PresentationDetent = .fraction(1/4)
    @State private var sheetScreen: SheetScreen = .places
    
    // Constants
    private let availableDetents: Set<PresentationDetent> = [.fraction(1/4), .fraction(0.8)]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TripItineraryView(
                trip: trip,
                startDate: trip.startDate ?? .now,
                endDate: trip.endDate ?? .now)
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                todoButton
            }
        }
        .onChange(of: sheetScreen, { oldValue, newValue in
            switch sheetScreen {
            case .places:
                selectedDetent = .fraction(1/4)
            case .todos:
                selectedDetent = .fraction(0.8)
            }
        })
        .sheet(isPresented: .constant(true)) {
            NavigationStack {
                switch sheetScreen {
                case .places:
                    PlaceList(trip: trip)
                case .todos:
                    TodoListView(tripId: trip.persistentModelID)
                }
            }
            .presentationDetents(availableDetents, selection: $selectedDetent)
            .presentationBackgroundInteraction(.enabled)
        }
    }
    
    // MARK: - Subviews
    private var todoButton: some View {
        Button {
            withAnimation {
                sheetScreen = sheetScreen == .places ? .todos : .places
            }
        } label: {
            Image(systemName: sheetScreen == .todos
                  ? "chevron.down.circle.fill"
                  : "checklist")
            .resizable()
            .animation(.smooth, value: sheetScreen)
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
        }
    }
}
