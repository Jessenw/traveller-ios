//
//  PlaceRow.swift
//  Traveller
//
//  Created by Jesse Williams on 25/07/2024.
//

import SwiftUI

struct PlaceRow: View {

    // Properties
    var place: Place
    var showConnectors: Bool = false
    var isLast: Bool = false
    
    // Constants
    let iconSize: CGFloat = 20

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .boldSubheadline()
                Text(place.subtitle?.formattedPlaceSubtitle ?? "")
                    .secondaryCaption()
            }
            .padding(showConnectors ? [.bottom] : [])
            .lineLimit(2)
        }
        .background {
            if showConnectors, !isLast {
                GeometryReader { geometry in
                    let connectorHeight = geometry.size.height - iconSize
                    Rectangle()
                        .foregroundStyle(.separator)
                        .position(
                            x: iconSize / 2,
                            y: iconSize + (connectorHeight / 2)
                        )
                        .frame(
                            width: 1,
                            height: connectorHeight
                        )
                }
            }
        }
        .padding(showConnectors ? [.horizontal] : [])
    }
}
