//
//  String+Formatted.swift
//  Traveller
//
//  Created by Jesse Williams on 22/07/2024.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
