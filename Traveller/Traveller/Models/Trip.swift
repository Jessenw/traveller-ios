//
//  Trip.swift
//  Traveller
//
//  Created by Jesse Williams on 24/06/2024.
//

import Foundation
import SwiftUI

struct Trip: Identifiable {
    var id = UUID()
    var name: String
    var detail: String?
    var startDate: Date?
    var endDate: Date?
    var members: [Color] = [] // TODO: Create Member model
    var places: [String] = [] // TODO: Create Place model
    var tasks: [String] = [] // TODO: Create Task model
}
