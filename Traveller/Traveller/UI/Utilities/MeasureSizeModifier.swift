//
//  MeasureSizeModifier.swift
//  Traveller
//
//  Created by Jesse Williams on 15/07/2024.
//

import SwiftUI

struct MeasureSizeModifier<Key: PreferenceKey>: ViewModifier where Key.Value == CGSize {
    let callback: (_ size: Key.Value) -> Void
    
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: Key.self, value: geometry.size)
            }
        )
        .onPreferenceChange(Key.self) { size in
            callback(size)
        }
    }
}
