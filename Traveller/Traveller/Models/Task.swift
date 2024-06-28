//
//  Task.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import Foundation

struct Task: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var additionalSubtitle: String
    var isChecked: Bool
    var imageName: String
}
