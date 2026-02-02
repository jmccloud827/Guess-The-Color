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
        .foregroundStyle(LinearGradient(gradient: Gradient(colors: makeHueColors(stepSize: 0.01)), startPoint: .trailing, endPoint: .topLeading))
            .frame(width: 250, height: 250)
        .padding()
        .padding()
        .padding(44)
        .background(.black)
    
    func makeHueColors(stepSize: Double) -> [Color] {
        stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        }
    }
}
