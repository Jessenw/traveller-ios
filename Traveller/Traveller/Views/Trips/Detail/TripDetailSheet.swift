//
//  TripDetailSheet.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import GooglePlaces
import GoogleMaps
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
                                        places = try await fetchAutocompletePredictions(query: searchText)
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
    
    /// Query Google Places to retrieve a list of fuzzy results
    private func fetchAutocompletePredictions(query: String) async throws -> [Place] {
        let gmsPlaces: [GMSPlace] = try await withCheckedThrowingContinuation { continuation in
            let placeProperties = [
                GMSPlaceProperty.placeID,
                GMSPlaceProperty.name,
                GMSPlaceProperty.photos
            ].map { $0.rawValue }

            let request = GMSPlaceSearchByTextRequest(
                textQuery: query,
                placeProperties: placeProperties)
            
            placesClient.searchByText(with: request) { (results, error) in
                guard let results, error == nil else {
                    print("Error fetching autocomplete places: \(error!.localizedDescription)")
                    continuation.resume(throwing: error!)
                    return
                }
                
//                print("Search results \(results.first!)")
                continuation.resume(returning: results)
            }
        }
        
        // Load photos
        var localPlaces = [Place]()
        for place in gmsPlaces {
            let photos = try await fetchPlacePhotos(placeId: place.placeID ?? "")
            
            let newPlace = Place(
                name: place.name ?? "",
                subtitle: place.formattedAddress ?? "",
                images: [])
            
            localPlaces.append(newPlace)
        }
        return localPlaces
    }
    
    private func fetchPlacePhotos(placeId: String) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            // Request list of photos for a place
            placesClient.lookUpPhotos(forPlaceID: placeId) { (photos, error) in
                guard let photoMetadata = photos?.results[0] else {
                    continuation.resume(throwing: URLError(.unknown))
                    return
                }

                // Request individual photos in the response list
                let fetchPhotoRequest = GMSFetchPhotoRequest(photoMetadata: photoMetadata, maxSize: CGSizeMake(400, 400))
                placesClient.fetchPhoto(with: fetchPhotoRequest) { (photoImage, error) in
                    guard let pngData = photoImage?.pngData(), error == nil else {
                        print("Error fetching photo: \(error!.localizedDescription)")
                        continuation.resume(throwing: error!)
                        return
                    }
                    
                    continuation.resume(returning: pngData)
                }
            }
        }
    }
}
