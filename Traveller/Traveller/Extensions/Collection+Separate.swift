//
//  Collection+Separate.swift
//  Traveller
//
//  Created by Jesse Williams on 29/06/2024.
//

extension Collection {
    func separate(predicate: (Element) -> Bool) -> (matching: [Element], notMatching: [Element]) {
        var matching: [Element] = []
        var notMatching: [Element] = []
        
        for element in self {
            if predicate(element) {
                matching.append(element)
            } else {
                notMatching.append(element)
            }
        }
        
        return (matching, notMatching)
    }
}
