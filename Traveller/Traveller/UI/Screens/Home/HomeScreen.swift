//
//  HomeScreen.swift
//  Traveller
//
//  Created by Jesse Williams on 04/07/2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var isShowingSheet = true
    
    var body: some View {
        MapContainerView()
            .sheet(isPresented: $isShowingSheet) {
                TripList()
                    .presentationDetents([
                        .fraction(1/3),
                        .fraction(0.999)
                    ])
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
            }
    }
}

#Preview {
    HomeScreen()
}
