//
//  TripDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import Combine
import GooglePlacesSwift
import GoogleMaps
import MijickCalendarView
import SwiftUI

struct TripDetail: View {
    @State private var places = [Place]()
    
    @EnvironmentObject private var tripContext: TripContext
    @ObservedObject private var placesService = PlacesService.shared
    
    @State private var currentScreen: TripDetailScreen = .calendar
    
    var trip: Trip
    
    var body: some View {
        VStack {
            switch currentScreen {
            case .places:
                PlaceList(tripId: trip.persistentModelID)
            case .calendar:
                CalendarScreen(trip: trip)
            case .todo:
                TaskList(tripId: trip.persistentModelID)
            case .budget:
                BudgetScreen(trip: trip)
            }
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                ForEach(TripDetailScreen.allCases) { context in
                    Spacer()
                    Button {
                        currentScreen = context
                    } label: {
                        Image(systemName: context.image)
                    }
                    Spacer()
                }
            }
        }
    }
}

enum TripDetailScreen: CaseIterable, Identifiable {
    case places
    case calendar
    case todo
    case budget
    
    var id: Int { self.hashValue }
    
    var image: String {
        switch self {
        case .places:
            "mappin.circle.fill"
        case .calendar:
            "calendar"
        case .todo:
            "checklist"
        case .budget:
            "dollarsign.circle.fill"
        }
    }
}
