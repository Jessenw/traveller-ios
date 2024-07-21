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
    @State private var places = [AutocompletePlace]()
    
    @State private var selectedItem: AutocompletePlace?
    @Binding var searchText: String

    var body: some View {
        NavigationStack {
            List(places) { place in
                PlaceSearchRow(place: place)
                    .onTapGesture {
                        selectedItem = place
                    }
            }
            .sheet(item: $selectedItem, content: { item in
                PlaceDetail(placeId: item.placeId)
            })
            .onChange(of: searchText) { _, newValue in
                _Concurrency.Task {
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
