//
//  TripList.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftData
import SwiftUI

struct TripList: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query private var trips: [Trip]
    @State private var showingCreateTripDialog = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Trips")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        showingCreateTripDialog = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding()
                
                List {
                    ForEach(trips) { trip in
                        TripRow(trip: trip)
                    }
                    .onDelete(perform: deleteTrip)
                }
                .listRowSpacing(8)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreateTripDialog) {
            CreateTripDialog()
        }
    }
    
    private func deleteTrip(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(trips[index])
        }
    }
}
