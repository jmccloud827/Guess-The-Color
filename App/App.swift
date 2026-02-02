import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GameSelection()
            }
        }
    }
}

/// App Icon
#Preview {
    return Image(systemName: "paintpalette")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.black)
            .frame(width: 250, height: 250)
        .padding()
        .padding()
        .padding(44)
        .background {
            LinearGradient(gradient: Gradient(colors: makeHueColors(stepSize: 0.01)), startPoint: .trailing, endPoint: .topLeading)
        }
    
    func makeHueColors(stepSize: Double) -> [Color] {
        stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        }
    }
}
