import SwiftUI

struct ContentView: View {
    @StateObject private var sheetState = ResizableSheetState()

    var body: some View {
        HomeScreen()
            .environmentObject(sheetState)
    }
}

#Preview {
    ContentView()
}
