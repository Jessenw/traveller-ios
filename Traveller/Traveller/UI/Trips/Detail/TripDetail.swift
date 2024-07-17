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
    @EnvironmentObject var sheetState: ResizableSheetState
    
    var trip: Trip
    var dismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    // Trip detail
                    if let detail = trip.detail {
                        Text(detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    
                    // Trip dates/members
                    HStack {
                        if let startDate = trip.startDate, let endDate = trip.endDate {
                            TripDatesView(startDate: startDate, endDate: endDate)
                        }
                        
                        AvatarsView(members: trip.members)
                    }
                }
                
                Spacer()
            }
            
            // Places, tasks and search lists
            VStack {
                Picker(String(localized: "Select list"), selection: $selectedSegment) {
                    Text(String(localized: "Places"))
                        .tag(0)
                    Text(String(localized: "Tasks"))
                        .tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if selectedSegment == 0 {
                    PlaceList(tripId: trip.persistentModelID)
                } else {
                    TaskList(tripId: trip.persistentModelID)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            sheetState.isFullscreen = true
            sheetState.headerTitle = !trip.name.isEmpty ? trip.name : nil
            sheetState.headerSubtitle = trip.detail
            sheetState.isHeaderButtonClose = true
            sheetState.headerButtonTapped = {
                dismiss()
            }
        }
    }
}
