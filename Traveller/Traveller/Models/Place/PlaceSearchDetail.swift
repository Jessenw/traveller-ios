//
//  PlaceSearchDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import Foundation

struct PlaceSearchDetail {
    var displayName: String?
    var photos: [Data]
    
    init(name: String?, photos: [Data]) {
        self.displayName = displayName?.isEmpty != nil ? name : nil
        self.photos = photos
    }
}
