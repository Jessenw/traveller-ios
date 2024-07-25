//
//  PlaceList.swift
//  Traveller
//
//  Created by Jesse Williams on 01/07/2024.
//

import SwiftData
import SwiftUI

struct PlaceList: View {
    @State private var searchText: String = ""
    @State private var searchIsFocused = false
    @State private var selectedItem: Place?
    
    var trip: Trip
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(searchText: $searchText, isFocused: $searchIsFocused)
                    .padding()
                
                if searchIsFocused {
                    PlaceSearchList(searchText: $searchText, trip: trip)
                } else {
                    List {
                        ForEach(trip.places) { place in
                            PlaceRow(place: place)
                                .onTapGesture {
                                    selectedItem = place
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .sheet(item: $selectedItem) { place in
                PlaceDetailView(placeId: place.id, trip: trip)
            }
        }
    }
}
