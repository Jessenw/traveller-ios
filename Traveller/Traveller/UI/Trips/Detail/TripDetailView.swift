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
    @State private var addSheetPresented = true
    @State private var selectedDetent: PresentationDetent = .fraction(1/4)
    
    // Constants
    private let availableDetents: Set<PresentationDetent> = [.fraction(1/4), .medium, .fraction(0.999)]
    
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
        .sheet(isPresented: $addSheetPresented) { addSheet }
        .sheet(isPresented: $todoSheetPresented, onDismiss: {
            selectedDetent = .fraction(1/4)
            addSheetPresented = true
        }, content: {
            todoSheet
        })
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
            .animation(.smooth, value: todoSheetPresented)
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
