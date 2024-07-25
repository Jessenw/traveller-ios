//
//  String+Formatted.swift
//  Traveller
//
//  Created by Jesse Williams on 22/07/2024.
//

extension String {
    var capitalizingFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
    
    var formattedPlaceSubtitle: String {
        self.replacingOccurrences(of: "_", with: " ").capitalizingFirstLetter
    }
}
