import SwiftUI

class TripContext: ObservableObject {
    @Published var trip: Trip?
    
    func updateTrip(_ newTrip: Trip) {
        trip = newTrip
    }
}

struct ContentView: View {
    var body: some View {
        TripList()
    }
}

#Preview {
    ContentView()
}
