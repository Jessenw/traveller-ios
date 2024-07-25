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
    var showSeparators: Bool
    var isLast: Bool
    
    // Constants
    let iconSize: CGFloat = 20
    
    init(place: Place, showSeparators: Bool, isLast: Bool) {
        self.place = place
        self.showSeparators = showSeparators
        self.isLast = isLast
    }
    
    init(place: Place) {
        self.init(place: place, showSeparators: false, isLast: false)
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .boldSubheadline()
                if let subtitle = place.subtitle {
                    Text(subtitle.formattedPlaceSubtitle)
                        .secondaryCaption()
                }
            }
            .lineLimit(2)
        }
        .background() {
            GeometryReader { geometry in
                if !isLast {
                    Rectangle()
                        .fill(.separator)
                        .position(
                            x: iconSize / 2,
                            y: geometry.size.height - iconSize)
                        .frame(width: 1, height: geometry.size.height - iconSize)
                }
            }
        }
    }
}
