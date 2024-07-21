//
//  AirportDateView.swift
//  Traveller
//
//  Created by Jesse Williams on 19/07/2024.
//

import SwiftUI

struct AirportDateView: View {
    @Binding var date: Date
    @State private var flipping = false
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<10) { index in
                FlipView(char: self.getChar(at: index))
            }
        }
        .onReceive(timer) { _ in
            self.updateDate()
        }
    }
    
    private func getChar(at index: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: date)
        return String(dateString[dateString.index(dateString.startIndex, offsetBy: index)])
    }
    
    private func updateDate() {
        withAnimation(.easeInOut(duration: 0.5)) {
            flipping.toggle()
            date = Date()
        }
    }
}

struct FlipView: View {
    let char: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.black)
                .frame(width: 30, height: 40)
            
            Text(char)
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}

#Preview {
    @State var date: Date = .now
    @State var isDateNow: Bool = true
    
    return VStack {
        Button(action: {
            isDateNow.toggle()
            date = isDateNow ? .now : .distantFuture
        }, label: {
            Text("New date")
        })
        AirportDateView(date: $date)
    }
}
