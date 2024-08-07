//
//  PlaceList.swift
//  Traveller
//
//  Created by Jesse Williams on 01/07/2024.
//

import SwiftData
import SwiftUI

struct PlaceList: View {
    @Environment(\.modelContext) private var modelContext
    
    var tripId: PersistentIdentifier
    
    var body: some View {
        List {
            if let trip: Trip = modelContext.registeredModel(for: tripId) {
                ForEach(trip.places) { PlaceRow(place: $0) }
            }
        }
        .listStyle(PlainListStyle())
    }
}

fileprivate struct CreateTaskButton: View {
    @Binding var showingCreateDialog: Bool
    
    private static let size: CGFloat = 24
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showingCreateDialog = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: Self.size, height: Self.size)
                }
            }
        }
    }
}

