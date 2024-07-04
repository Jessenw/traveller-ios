//
//  TripDetailSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import Combine
import GooglePlacesSwift
import GoogleMaps
import SwiftUI

struct TripDetailSheet: View {
    @State private var selectedSegment = 0
    @State private var searchText = ""
    @State private var searchIsFocused = false
    @State private var places = [Place]()
    @ObservedObject var placesService = PlacesService()
    
    var trip: Trip
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        // Trip name
                        Text(trip.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Trip detail
                        if let detail = trip.detail {
                            Text(detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        
                        // Trip dates
                        HStack {
                            if let startDate = trip.startDate, let endDate = trip.endDate {
                                HStack {
                                    Image(systemName: "calendar")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text("\(startDate.formatted) - \(endDate.formatted)")
                                        .font(.caption)
                                }
                                .foregroundStyle(.secondary)
                            }
                            
                            if (!trip.members.isEmpty) {
                                Text("•")
                            }
                            
                            // Member avatars
                            HStack(spacing: 4) {
                                ForEach(trip.members, id: \.self) { member in
                                    Circle()
                                        .fill(Utilities.randomColor())
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .padding([.horizontal, .top])
            
            // Places, tasks and search lists
            VStack {
                Picker("Select List", selection: $selectedSegment) {
                    Text("Places").tag(0)
                    Text("Tasks").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedSegment == 0 {
                    SearchBar(searchText: $searchText)
                        .padding(.horizontal)
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
                            
                            withAnimation {
                                searchIsFocused = !newValue.isEmpty ? true : false
                            }
                        }
                    
                    if searchIsFocused {
                        PlaceSearchList(places: $places, trip: trip)
                    } else {
                        PlaceList(tripId: trip.persistentModelID)
                    }
                } else {
                    TaskList(tripId: trip.persistentModelID)
                }
            }
            
            Spacer()
        }
    }
}
