//
//  MapViewController.swift
//  Traveller
//
//  Created by Jesse Williams on 25/06/2024.
//

import GoogleMaps
import SwiftUI
import UIKit

/// Host ViewController for the GoogleMaps MapView
class MapViewController: UIViewController {
    let map = GMSMapView()
    var isAnimating: Bool = false
    
    override func loadView() {
        super.loadView()
        self.view = map
    }
}

/// Bridging controller for the GoogleMaps MapView as it doesn't
/// natively support SwiftUI yet.
struct MapViewControllerBridge: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MapViewController {
        MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) { }
}
