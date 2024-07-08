//
//  TripDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import Combine
import GooglePlacesSwift
import GoogleMaps
import SwiftUI

struct TripDetail: View {
    @State private var selectedSegment = 0
    @State private var places = [Place]()
    @ObservedObject var placesService = PlacesService.shared
    
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
                                    
                                    if (!trip.members.isEmpty) {
                                        Text("•")
                                    }
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
                    }
                    
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
                    PlaceList(tripId: trip.persistentModelID)
                } else {
                    TaskList(tripId: trip.persistentModelID)
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}
