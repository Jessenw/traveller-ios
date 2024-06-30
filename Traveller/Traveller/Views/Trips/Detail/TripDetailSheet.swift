//
//  TripDetailSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import GooglePlaces
import SwiftUI

struct TripDetailSheet: View {
    @State private var selectedSegment = 0
    @State private var searchText = ""
    @State private var searchIsFocused = false
    @State private var places = [Place]()
    
    var trip: Trip
    private var placesClient = GMSPlacesClient.shared()
    
    init(trip: Trip) {
        self.trip = trip
    }
    
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
                                    Text("•")
                                }
                                .foregroundStyle(.secondary)
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
            
            VStack {
                Picker("Select List", selection: $selectedSegment) {
                    Text("Places").tag(0)
                    Text("Tasks").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if selectedSegment == 0 {
                    SearchView(searchText: $searchText)
                        .onChange(of: searchText) { oldValue, newValue in
                            fetchPlaces()
                            withAnimation {
                                searchIsFocused = !newValue.isEmpty ? true : false
                            }
                        }
                    
                    if searchIsFocused {
                        PlaceSearchList(places: $places)
                    } else {
                        // PlaceList(tripId: trip.persistentModelId)
                        TaskList(tripId: trip.persistentModelID)
                    }
                } else {
                    TaskList(tripId: trip.persistentModelID)
                }
            }
            
            Spacer()
        }
    }
    
    /// Query Google Places to retrieve a list of fuzzy results
    private func fetchPlaces() {
        placesClient.findAutocompletePredictions(
            fromQuery: searchText,
            filter: nil,
            sessionToken: nil
        ) { (results, error) in
            if let error = error {
                print("Error fetching autocomplete predictions: \(error.localizedDescription)")
                return
            }
            places = results?.map { prediction in
                Place(
                    title: prediction.attributedPrimaryText.string,
                    subtitle: prediction.attributedSecondaryText?.string ?? "")
            } ?? []
        }
    }
}

struct SearchView: View {
    @Binding var searchText: String
    
    var body: some View {
        TextField("Search for places...", text: $searchText)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}
