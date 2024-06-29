//
//  Task.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import Foundation
import SwiftData

@Model class Task {
    var title: String
    var notes: String?
    var deadline: Date?
    var isChecked: Bool
    
    init(
        title: String,
        notes: String? = nil,
        deadline: Date? = nil,
        isChecked: Bool = false
    ) {
        self.title = title
        self.notes = (notes?.isEmpty ?? true) ? nil : notes
        self.deadline = deadline
        self.isChecked = isChecked
    }
}
