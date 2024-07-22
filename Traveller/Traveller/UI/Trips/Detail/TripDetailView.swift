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

struct TripDetailView: View {
    // Properties
    @ObservedObject private var placesService = PlacesService.shared
    
    let trip: Trip
    
    // State
    @State private var todoSheetPresented = false
    @State private var selectedDetent: PresentationDetent = .medium
    
    // Constants
    private let availableDetents: Set<PresentationDetent> = [.medium, .large]

    var body: some View {
        VStack {
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
        .sheet(isPresented: $todoSheetPresented) {
            todoSheet
        }
    }
    
    // MARK: - Subviews
    private var todoButton: some View {
        Button {
            todoSheetPresented.toggle()
        } label: {
            Image(systemName: todoSheetPresented
                  ? "chevron.down.circle.fill"
                  : "checklist")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
        }
    }
    
    private var todoSheet: some View {
        NavigationStack {
            TaskList(tripId: trip.persistentModelID)
        }
        .presentationDetents(availableDetents, selection: $selectedDetent)
        .presentationBackgroundInteraction(.enabled)
    }
}
