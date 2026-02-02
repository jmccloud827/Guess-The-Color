import SwiftUI

struct GameSelection: View {
    @State private var game: Game? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                makeDifficultyLevel(mode: .regular)
                
                makeDifficultyLevel(mode: .hard)
                
                makeDifficultyLevel(mode: .impossible)
            }
            .padding(.horizontal)
        }
        .fullScreenCover(item: $game) { game in
            GameView(game: game)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Guess the Color")
                    .font(.title)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: self.makeHueColors(stepSize: 0.01)), startPoint: .leading, endPoint: .trailing))
            }
        }
    }
    
    private func makeDifficultyLevel(mode: Game.Mode) -> some View {
        Button {
            game = .init(mode: mode)
        } label: {
            HStack {
                Gauge(value: mode.gaugeValue) {
                    Text("")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(mode.gaugeColor.gradient)
                .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text(mode.title)
                        .font(.title)
                        .foregroundStyle(mode.gaugeColor)
                    
                    Text(mode.description)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 50))
        }
        .buttonStyle(.plain)
    }
    
    private func makeHueColors(stepSize: Double) -> [Color] {
        stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        }
    }
}

#Preview {
    NavigationStack {
        GameSelection()
    }
}
