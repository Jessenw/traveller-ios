import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @State private var nextView: (any View)?
    @State private var presentTray: Bool = false
    
    var body: some View {
        ZStack {
            List {
                Text("Row 1")
                    .onTapGesture {
                        presentTray = true
                    }
                Text("Row 2")
            }
        }
        
        if presentTray {
            HStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 20, style: .circular)
            }
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
