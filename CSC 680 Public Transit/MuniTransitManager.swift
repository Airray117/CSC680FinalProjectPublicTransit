import CoreLocation
import Combine

class MuniTransitManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var arrivalTimes: [MuniArrival] = []
    @Published var isFetchingData = false
    
    private var cancellables = Set<AnyCancellable>()
    let locationManager = CLLocationManager()
    
    // MARK: - API Details
    private let apiBaseURL = "http://webservices.nextbus.com/service/publicJSONFeed"
    private let muniAgency = "sf-muni"

    // MARK: - Initialization
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Request Location Authorization
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            fetchNearestTransitStop(location: location.coordinate)
        }
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }

    // MARK: - Fetch Nearest Transit Stop Based on Location
    func fetchNearestTransitStop(location: CLLocationCoordinate2D) {
        isFetchingData = true
        
        // Call the Muni API to fetch the stops
        guard let url = URL(string: "\(apiBaseURL)?command=routeConfig&a=\(muniAgency)") else {
            print("Invalid API URL")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RouteConfigResponse.self, decoder: JSONDecoder())
            .map { response in
                // Find the closest stop
                let stops = response.routes.flatMap { $0.stops }
                return self.findNearestStop(location: location, stops: stops)
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nearestStop in
                guard let stop = nearestStop else {
                    print("No stops found nearby.")
                    self?.isFetchingData = false
                    return
                }
                print("Nearest stop: \(stop.title)")
                self?.fetchArrivalTimes(for: stop.stopId, stopName: stop.title)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Fetch Arrival Times for a Stop
    func fetchArrivalTimes(for stopId: String, stopName: String) {
        guard let url = URL(string: "\(apiBaseURL)?command=predictions&a=\(muniAgency)&stopId=\(stopId)") else {
            print("Invalid API URL for predictions")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PredictionsResponse.self, decoder: JSONDecoder())
            .map { response in
                response.predictions.flatMap { prediction in
                    prediction.direction.predictions.map { pred in
                        MuniArrival(stopId: stopId, stopName: stopName, time: pred.minutes)
                    }
                }
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] arrivals in
                self?.arrivalTimes = arrivals
                self?.isFetchingData = false
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Find Nearest Stop Logic
    func findNearestStop(location: CLLocationCoordinate2D, stops: [Stop]) -> Stop? {
        return stops.min(by: { stop1, stop2 in
            let distance1 = location.distance(to: stop1.coordinate)
            let distance2 = location.distance(to: stop2.coordinate)
            return distance1 < distance2
        })
    }
}

// MARK: - Extensions for CLLocationCoordinate2D
extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let loc1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let loc2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return loc1.distance(from: loc2)
    }
}

// MARK: - Data Models
struct RouteConfigResponse: Codable {
    let routes: [Route]
}

struct Route: Codable {
    let stops: [Stop]
}

struct Stop: Codable, Identifiable {
    let id: String
    let stopId: String
    let title: String
    let lat: String
    let lon: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(lon) ?? 0)
    }
}

struct PredictionsResponse: Codable {
    let predictions: [Prediction]
}

struct Prediction: Codable {
    let direction: Direction
}

struct Direction: Codable {
    let predictions: [ArrivalPrediction]
}

struct ArrivalPrediction: Codable {
    let minutes: Int
}

struct MuniArrival: Identifiable {
    let id = UUID()
    let stopId: String
    let stopName: String
    let time: Int
}
