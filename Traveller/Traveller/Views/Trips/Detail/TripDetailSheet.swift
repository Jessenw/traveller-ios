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

@MainActor
class TripDetailSheetViewModel: ObservableObject {
    
    let placesClient = PlacesClient.shared
    
    /// Query Google Places to retrieve a list of fuzzy results
    func fetchAutocompletePredictions(query: String) async throws -> [Place] {
        let filter = AutocompleteFilter(types: [.restaurant])
        let autocompleteRequest = AutocompleteRequest(query: query, filter: filter)
        
        let placeIds: [String] = switch await placesClient.fetchAutocompleteSuggestions(with: autocompleteRequest) {
            case .success(let autocompleteSuggestions):
                try autocompleteSuggestions.map { suggestion -> String in
                    switch suggestion {
                    case .place(let place):
                        return place.placeID
                    @unknown default:
                        throw(PlacesError.internal("Unknown AutocompleteSuggestion type"))
                    }
                }
            case .failure(let placesError):
                throw placesError
        }
        
        var newPlaces = [Place]()
        for placeId in placeIds {
            let fetchPlaceRequest = FetchPlaceRequest(
                placeID: placeId,
                placeProperties: [
                    PlaceProperty.displayName,
                    PlaceProperty.formattedAddress,
                    PlaceProperty.photos
                ]
            )
            var fetchedPlace: GooglePlacesSwift.Place
            switch await placesClient.fetchPlace(with: fetchPlaceRequest) {
            case .success(let place):
                fetchedPlace = place
            case .failure(let placesError):
                throw(PlacesError.internal("Error fetching place \(placesError)"))
            }
            
            // Use the place details to fetch a photo's image.
            guard let photos = fetchedPlace.photos else {
                return []
            }
            
            var photosData = [Data]()
            for photo in photos {
                let fetchPhotoRequest = FetchPhotoRequest(photo: photo, maxSize: CGSizeMake(200, 200))
                switch await placesClient.fetchPhoto(with: fetchPhotoRequest) {
                case .success(let uiImage):
                    if let photoData = uiImage.pngData() {
                        photosData.append(photoData)
                    }
                case .failure(let placesError):
                    throw(PlacesError.internal("Error fetching photo \(placesError)"))
                }
            }
            
            let newPlace = Place(
                name: fetchedPlace.displayName ?? "",
                subtitle: fetchedPlace.formattedAddress ?? "",
                images: photosData)
            newPlaces.append(newPlace)
        }
        return newPlaces
    }
}

struct TripDetailSheet: View {
    @State private var selectedSegment = 0
    @State private var searchText = ""
    @State private var searchIsFocused = false
    @State private var places = [Place]()
    @ObservedObject var viewModel = TripDetailSheetViewModel()
    
    var trip: Trip
        
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
                                        places = try await viewModel.fetchAutocompletePredictions(query: searchText)
                                        print(places)
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
