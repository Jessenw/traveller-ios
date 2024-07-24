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
    @State private var addSheetPresented = false
    @State private var placesSheetPresented = false
    @State private var selectedDetent: PresentationDetent = .medium
    
    // Constants
    private let availableDetents: Set<PresentationDetent> = [.medium, .large]
    
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
        .sheet(isPresented: $todoSheetPresented) { todoSheet }
        .sheet(isPresented: $addSheetPresented) { addSheet }
    }
    
    // MARK: - Subviews
    private var todoButton: some View {
        Button {
            if todoSheetPresented || addSheetPresented {
                // Dismiss all sheets
                todoSheetPresented = false
                addSheetPresented = false
            } else if !todoSheetPresented {
                todoSheetPresented = true
            }
        } label: {
            Image(systemName: (todoSheetPresented || addSheetPresented)
                  ? "chevron.down.circle.fill"
                  : "checklist")
            .resizable()
            .animation(.smooth, value: todoSheetPresented)
            .animation(.smooth, value: addSheetPresented)
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25)
        }
    }
    
    private var todoSheet: some View {
        NavigationStack {
            TodoListView(tripId: trip.persistentModelID)
        }
        .presentationDetents(availableDetents, selection: $selectedDetent)
        .presentationBackgroundInteraction(.enabled)
    }
    
    private var addSheet: some View {
        NavigationStack {
            PlaceList(trip: trip)
        }
        .presentationDetents(availableDetents, selection: $selectedDetent)
        .presentationBackgroundInteraction(.enabled)
    }
}

struct FloatingActionButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .padding()
    }
}
