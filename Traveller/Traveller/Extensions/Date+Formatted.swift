//
//  Date+Formatted.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

import Foundation

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M"
        return formatter.string(from: self)
    }
}
