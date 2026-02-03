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
            LinearGradient(gradient: hueGradient, startPoint: .trailing, endPoint: .topLeading)
        }
}
