import SwiftUI
import MapKit
import CoreLocation

import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct MapWithPinView: View {
    @Binding var pinLocation: CLLocationCoordinate2D

    // Center map at San Francisco initially
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                .onChange(of: region.center) { oldValue, newValue in
                    pinLocation = newValue
                }
            
            VStack {
                Spacer()
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
                Spacer()
            }
        }
        .onAppear {
            // Set initial map location
            region.center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            pinLocation = region.center
        }
    }
}

// MARK: - Helper Struct to Place Pins
struct MapPinItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
