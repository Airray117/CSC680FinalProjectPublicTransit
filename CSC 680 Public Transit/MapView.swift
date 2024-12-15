//
//  MapView.swift
//  CSC 680 Public Transit
//
//  Created by Raymond Liu on 10/31/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default: SF
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: locationManager.transitStops) { stop in
            MapMarker(coordinate: stop.coordinate, tint: .blue)
        }
        .onAppear {
            locationManager.requestLocation()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(LocationManager()) // Provide a sample LocationManager
    }
}

