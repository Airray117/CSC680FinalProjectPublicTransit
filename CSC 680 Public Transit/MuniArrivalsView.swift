import SwiftUI

struct MuniArrivalsView: View
{
    @ObservedObject var manager: MuniTransitManager

    var body: some View
    {
        NavigationView
        {
            VStack
            {
                if manager.isFetchingData
                {
                    ProgressView("Fetching Muni arrival times...")
                } else if manager.arrivalTimes.isEmpty
                {
                    Text("No Muni stops found near the selected location.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                else
                {
                    List(manager.arrivalTimes)
                    { arrival in
                        VStack(alignment: .leading, spacing: 5)
                        {
                            Text("Stop: \(arrival.stopName)")
                                .font(.headline)
                            Text("Next Bus Arrival: \(arrival.time) minutes")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("Muni Arrivals")
        }
    }
}

// MARK: - Preview
struct MuniArrivalsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        // Mock MuniTransitManager for Preview
        let mockManager = MuniTransitManager()
        mockManager.arrivalTimes = [
            MuniArrival(stopId: "1234", stopName: "Market St & 8th St", time: 5),
            MuniArrival(stopId: "5678", stopName: "Van Ness Ave & Geary St", time: 10)
        ]
        return MuniArrivalsView(manager: mockManager)
    }
}

//struct MuniArrivalsView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Instantiate MuniTransitManager
//        let realManager = MuniTransitManager()
//
//        // Fetch arrival times for a known stop
//        DispatchQueue.main.async {
//            realManager.fetchArrivalTimes(for: "15687", stopName: "Market St & 8th St")
//        }
//
//        return MuniArrivalsView(manager: realManager)
//    }
//}
