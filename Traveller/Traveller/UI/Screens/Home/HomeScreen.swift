//
//  HomeScreen.swift
//  Traveller
//
//  Created by Jesse Williams on 04/07/2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var isShowingSheet = true
    @State private var searchIsFocused = false
    @State private var searchQuery = ""
    
    // Sheet presentation state
    @State private var currentDetent = PresentationDetent.fraction(1/3)
    @State private var dragIndicator = Visibility.visible
    @State private var sheetDetents = [PresentationDetent.fraction(1/3)]
    @State private var maxDetent = PresentationDetent.height(700)
    
    init() {
        sheetDetents.append(maxDetent)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TripList()
                Spacer()
            }
        }
    }
}

#Preview {
    HomeScreen()
}
