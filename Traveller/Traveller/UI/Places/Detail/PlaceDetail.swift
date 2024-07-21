//
//  PlaceDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import SwiftData
import SwiftUI

struct PlaceDetail: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    @ObservedObject private var placesService = PlacesService.shared
    @State private var place: PlaceSearchDetail?
    @State private var isSaved: Bool = false
    
    var placeId: String
    var trip: Trip?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Title and Subtitle
                VStack(alignment: .leading, spacing: 4) {
                    if let name = place?.name {
                        Text(name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    if let firstType = place?.types.first {
                        Text(firstType.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        // Hours
                        VStack(alignment: .leading) {
                            if let openingHours = place?.openingHours {
                                Text("\(openingHours.isOpen)")
                            }
                        }
                        // Reviews Summary
                        VStack(alignment: .leading) {
                            Text("Rating")
                                .font(.headline)
                            if let rating = place?.rating {
                                Text("\(rating)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        // Average Cost
                        VStack(alignment: .leading) {
                            Text("Price")
                                .font(.headline)
                            if let priceLevel = place?.priceLevel {
                                Text(priceLevel.priceLevelDescription)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Image Carousel
                if let images = place?.images {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(images, id: \.self) { imageData in
                                if let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 150)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarItems(
                leading: Button(action: {
                    // Action for closing the screen
                }) {
                    Image(systemName: "xmark")
                },
                trailing: Button(action: {
                    // Action for adding to a list
                }) {
                    Image(systemName: "plus")
                }
            )
            .task {
                do {
                    self.place = try await placesService
                        .fetchPlaceDetails(placeId: placeId)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func saveTrip() {
        if let place {
            trip?.places.append(place.toPlace())
        }
    }
    
    private func removeTrip() {
        trip?.places.removeAll {
            $0.googleId == placeId
        }
    }
}
