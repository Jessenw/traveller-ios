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
    @ObservedObject var placesService = PlacesService.shared
    @State private var places = [AutocompletePlace]()
    
    @Binding var searchQuery: String

    var body: some View {
            List(places) { place in
                NavigationLink(destination: PlaceDetail(placeId: place.placeId)) {
                    PlaceSearchRow(place: place)
                }
            }
            .onChange(of: searchQuery) { _, newValue in
                _Concurrency.Task {
                    do {
                        if !searchQuery.isEmpty {
                            places = try await placesService.fetchAutocompletePredictions(query: searchQuery)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        
    }
}
