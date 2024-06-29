//
//  Utilities.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import SwiftUI

class Utilities {
    static func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        
        return Color(red: red, green: green, blue: blue)
    }
}
