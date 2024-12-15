//
//  LocationManager.swift
//  CSC 680 Public Transit
//
//  Created by Raymond Liu on 10/31/24.
//

import Foundation
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var transitStops: [TransitStop] = []  // Published array to store transit stops

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()  // Request a single location update
    }

    // CLLocationManager Delegate Method: Updates locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            fetchNearbyTransitStops(location: location)
        }
    }

    // CLLocationManager Delegate Method: Error Handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }

    private func fetchNearbyTransitStops(location: CLLocation)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "transit" // Search for "transit" stops
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else
            {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Map each transit stop to the TransitStop model
            self.transitStops = response.mapItems.compactMap
            { item in
                TransitStop(
                    id: item.name ?? UUID().uuidString, // Use the stop name as ID or generate a UUID
                    name: item.name ?? "Unknown Stop", // Fallback to "Unknown Stop" if name is nil
                    coordinate: item.placemark.coordinate
                )
            }
        }
    }
}
