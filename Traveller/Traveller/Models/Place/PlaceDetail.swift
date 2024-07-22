//
//  PlaceSearchDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import Foundation
import GooglePlacesSwift

struct PlaceDetail {
    var googleId: String
    var name: String?
    var formattedAddress: String?
    var priceLevel: PriceLevel
    var businessStatus: BusinessStatus
    var openingHours: OpeningHours?
    var rating: Float?
    var userRatingsCount: Int
    var websiteURL: URL?
    var images: [Photo]
    var types: Set<PlaceType>
    
    var isOpen: Bool? {
        openingHours?.isOpen
    }
    
    var firstTypeFormatted: String? {
        guard let type = types.first?.rawValue else {
            return nil
        }
        let replacedString = type.replacingOccurrences(of: "_", with: " ")
        return replacedString.capitalizingFirstLetter()
    }
}

func isTimeWithinRange(date: Date, startTime: (hour: Int, minute: Int), endTime: (hour: Int, minute: Int)) -> Bool {
    let calendar = Calendar.current
    
    // Extract hour and minute components from the given date
    let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
    guard let hour = dateComponents.hour, let minute = dateComponents.minute else {
        return false
    }
    
    // Convert times to minutes for easier comparison
    let dateTimeInMinutes = hour * 60 + minute
    let startTimeInMinutes = startTime.hour * 60 + startTime.minute
    let endTimeInMinutes = endTime.hour * 60 + endTime.minute
    
    // Check if the time falls within the range
    if endTimeInMinutes > startTimeInMinutes {
        // Normal case: start time is before end time
        return dateTimeInMinutes >= startTimeInMinutes && dateTimeInMinutes <= endTimeInMinutes
    } else {
        // Special case: end time is on the next day
        return dateTimeInMinutes >= startTimeInMinutes || dateTimeInMinutes <= endTimeInMinutes
    }
}

extension PlaceDetail {
    func toPlace() -> Place {
        Place(
            googleId: self.googleId,
            name: self.name ?? "",
            subtitle: self.types.first?.rawValue ?? "Outdoors store",
            images: [])
    }
}
