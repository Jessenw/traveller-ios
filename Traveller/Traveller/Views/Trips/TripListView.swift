//
//  TripListView.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftUI

struct TripListView: View {
    @State var trips: [Trip] = []
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
                        VStack(alignment: .leading) {
                            TripRow(trip: trip)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreateTripDialog) {
            CreateTripDialog(trips: $trips)
        }
    }
}

#Preview {
    TripListView()
}
