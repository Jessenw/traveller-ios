//
//  HomeScreen.swift
//  Traveller
//
//  Created by Jesse Williams on 04/07/2024.
//

import SwiftUI

enum ScreenContext {
    case home
    case trip
}

struct HomeScreen: View {
    @State private var searchIsFocused = false
    @State private var searchQuery = ""
    @State private var screenContext: ScreenContext = .home
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapContainerView()
                VStack {
                    SearchBar(
                        searchText: $searchQuery,
                        isFocused: $searchIsFocused,
                        screenContext: $screenContext
                    )
                    .padding([.top, .horizontal])
                    
                    Spacer()
                    
                    ResizableAnchoredSheet {
                        HStack {
                            Text("Trips")
                                .font(.title)

                            Spacer()

                            Button(
                                action: {},
                                label: {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(.primary)
                                }
                            )
                            .buttonStyle(PlainButtonStyle())
                        }
                    } content: {
                        TripList()
                            .backgroundStyle(.clear)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
