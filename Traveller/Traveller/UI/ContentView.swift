import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        HomeScreen()
    }
}

#Preview {
    ContentView()
}
