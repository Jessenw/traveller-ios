//
//  PlaceList.swift
//  Traveller
//
//  Created by Jesse Williams on 01/07/2024.
//

import SwiftData
import SwiftUI

struct PlaceList: View {
    @Environment(\.modelContext) private var modelContext
    
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
                PlaceDetailView(placeId: place.googleId, trip: trip)
            }
        }
    }
}

fileprivate struct CreateTaskButton: View {
    @Binding var showingCreateDialog: Bool
    
    private static let size: CGFloat = 24
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showingCreateDialog = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: Self.size, height: Self.size)
                }
            }
        }
    }
}

