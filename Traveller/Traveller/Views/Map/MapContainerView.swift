//
//  MapContainerView.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

struct MapContainerView: View {
    var body: some View {
        MapViewControllerBridge()
            .ignoresSafeArea(edges: .vertical)
    }
}

#Preview {
    MapContainerView()
}
