//
//  PlacesSearchList.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import GoogleMaps
import GooglePlaces
import SwiftData
import SwiftUI

struct PlaceSearchList: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @EnvironmentObject private var tripContext: TripContext
    @ObservedObject var placesService = PlacesService.shared
    @State private var places = [Place]()
    
    @State private var selectedItem: Place?
    @State private var sheetDetent: PresentationDetent = .medium
    @Binding var searchText: String
    
    var trip: Trip?

    var body: some View {
        NavigationStack {
            List(places) { place in
                PlaceRow(place: place)
                    .onTapGesture {
                        selectedItem = place
                    }
            }
            .listStyle(.plain)
            .sheet(item: $selectedItem) { place in
                PlaceDetailView(placeId: place.googleId, trip: trip)
            }
            .presentationDetents([.medium], selection: $sheetDetent)
            .onChange(of: searchText) { _, newValue in
                Task {
                    do {
                        if !searchText.isEmpty {
                            places = try await placesService.fetchAutocompletePredictions(query: searchText)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
