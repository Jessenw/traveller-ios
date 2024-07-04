//
//  PlaceSearchRow.swift
//  Traveller
//
//  Created by Jesse Williams on 01/07/2024.
//

import SwiftUI

struct PlaceSearchRow: View {
    let trip: Trip
    let place: Place
    
    @State private var isAdded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // Preview images
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(place.images, id: \.self) { imageData in
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 90, height: 90)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(place.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        isAdded.toggle()
                        addPlace(place: place)
                    }
                }) {
                    Text(isAdded ? "Added" : "Add")
                        .padding()
                        .background(isAdded ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private func addPlace(place: Place) {
        trip.places.append(place)
    }
}

#Preview {
    PlaceSearchRow(
        trip: Trip(name: "Name"),
        place: Place(name: "Title", subtitle: "Subtitle", images: []))
}
