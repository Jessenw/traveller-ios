//
//  PlaceSearchDetail.swift
//  Traveller
//
//  Created by Jesse Williams on 05/07/2024.
//

import Foundation
import GooglePlacesSwift

struct PlaceSearchDetail {
    var googleId: String
    var name: String?
    var formattedAddress: String?
    var priceLevel: PriceLevel?
    var businessStatus: BusinessStatus?
    var openingHours: OpeningHours?
    var rating: Float?
    var userRatingsCount: Int?
    var websiteURL: URL?
    var images: [Data]
    var types: Set<PlaceType>
}

extension OpeningHours {
    var isOpen: Bool {
        let date = Date.now
        let dayIndex = dayOfWeekIndex(from: date)
        
        
        // See if there's a period whose day matches the current day
        guard let period = self.periods.first(where: { period in
            period.open.day.rawValue == dayIndex
        }) else {
            return false
        }
        
        return isTimeWithinRange(
            date: Date.now,
            startTime: (hour: Int(period.open.time.hour),
                        minute: Int(period.open.time.minute)),
            endTime: (hour:  Int(period.open.time.hour),
                      minute: Int(period.open.time.minute)))
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

func dayOfWeekIndex(from date: Date) -> Int {
    let calendar = Calendar.current
    return calendar.component(.weekday, from: date)
}

extension PriceLevel {
    var priceLevelDescription: String {
        switch self {
        case .unspecified: return "Unspecified"
        case .free: return "Free"
        case .inexpensive: return "Inexpensive"
        case .moderate: return "moderate"
        case .expensive: return "expensive"
        case .veryExpensive: return "Very expensive"
        @unknown default:
            fatalError("Unknown GMSPlacesPriceLevel: \(self)")
        }
    }
}

extension PlaceSearchDetail {
    func toPlace() -> Place {
        Place(
            googleId: self.googleId,
            name: self.name ?? "",
            subtitle: "subtitle",
            images: self.images)
    }
}
