//
//  TodoItem.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import Foundation

struct TodoItem: Identifiable {
    var id = UUID()
    var title: String
    var subheading: String
    var additionalSubheading: String
    var isChecked: Bool
    var imageName: String
}
