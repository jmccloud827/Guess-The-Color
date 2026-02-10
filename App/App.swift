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
    Image(systemName: "paintpalette")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(LinearGradient(gradient: .hue, startPoint: .trailing, endPoint: .topLeading))
            .frame(width: 250, height: 250)
        .padding()
        .padding()
        .padding(44)
        .background {
            Color.black
        }
}
