//
//  TripDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct TripDetail: View {
    var trip: Trip
    
    var body: some View {
        Text(trip.name)
    }
}
