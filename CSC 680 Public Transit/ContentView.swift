import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var manager = MuniTransitManager()
    @State private var locationPermissionDenied = false
    @State private var selectedPinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var body: some View {
        TabView {
            // Map Tab with Pin Selection
            ZStack {
                MapWithPinView(pinLocation: $selectedPinLocation)
                    .onChange(of: selectedPinLocation) { newValue in
                        // Update manager with selected location
                        if let safeLocation = Optional(newValue) {
                            manager.fetchNearestTransitStop(location: safeLocation)
                        } else {
                            print("Error: Pin location is nil!")
                        }
                    }
            }
            .tabItem {
                Label("Pick Location", systemImage: "map")
            }
            
            // Muni Stops Tab
            MuniArrivalsView(manager: manager)
                .tabItem {
                    Label("Muni Stops", systemImage: "tram.fill")
                }
                .onAppear {
                    checkLocationPermission()
                }
        }
    }
    
    // MARK: - Check Location Permission
    private func checkLocationPermission() {
        if CLLocationManager.authorizationStatus() == .denied {
            locationPermissionDenied = true
        } else {
            manager.requestLocationAuthorization() // Ensures location permission is requested
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

