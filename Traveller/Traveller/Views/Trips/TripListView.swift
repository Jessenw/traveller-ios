//
//  TripListView.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import SwiftUI

struct TripListView: View {
    @State var trips: [Trip] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Trips")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
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
    }
}

#Preview {
    TripListView()
}
