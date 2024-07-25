//
//  Member.swift
//  Traveller
//
//  Created by Jesse Williams on 30/06/2024.
//

import Foundation
import SwiftData

@Model class Member {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
