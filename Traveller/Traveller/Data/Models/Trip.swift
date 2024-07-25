//
//  Trip.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model class Trip: Identifiable {
    var id = UUID()
    var name: String
    var detail: String?
    var startDate: Date?
    var endDate: Date?
    @Relationship var members: [Member]
    @Relationship var places: [Place]
    @Relationship var todos: [Todo]
    
    init(
        name: String,
        detail: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        members: [Member] = [],
        places: [Place] = [],
        todos: [Todo] = []
    ) {
        self.id = UUID()
        self.name = name
        self.detail = detail
        self.startDate = startDate
        self.endDate = endDate
        self.members = members
        self.places = places
        self.todos = todos
    }
}
