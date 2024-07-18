//
//  PlaceSearchDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import Foundation

struct PlaceSearchDetail {
    var googleId: String
    var displayName: String?
    var photos: [Data]
    
    init(googleId: String, name: String?, photos: [Data]) {
        self.googleId = googleId
        self.displayName = displayName?.isEmpty != nil ? name : nil
        self.photos = photos
    }
}

extension PlaceSearchDetail {
    func toPlace() -> Place {
        Place(
            googleId: self.googleId,
            name: self.displayName ?? "",
            subtitle: "subtitle",
            images: self.photos)
    }
}
