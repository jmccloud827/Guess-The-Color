import SwiftUI

struct GameSelection: View {
    @State private var game: Game? = nil
    @State private var isPlusMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                makeDifficultyLevel(mode: .regular)
                
                makeDifficultyLevel(mode: .hard)
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
        .safeAreaInset(edge: .bottom) {
            Button {
                isPlusMode.toggle()
            } label: {
                Toggle(isOn: $isPlusMode) {
                    VStack(alignment: .leading) {
                        Text("+ Mode")
                            .font(.title2)
                        
                        Text("Questions stay the same but the answers are what I see...and I'm colorblind😈.")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
            .padding(.top)
            .padding(.horizontal)
        }
    }
    
    private func makeDifficultyLevel(mode: Game.Mode) -> some View {
        Button {
            game = .init(mode: mode, isPlusMode: isPlusMode)
        } label: {
            HStack {
                Gauge(value: mode.gaugeValue * (isPlusMode ? 2 : 1)) {
                    Text("")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(mode.gaugeColor.gradient)
                .padding(.trailing)
                .animation(.default, value: isPlusMode)
                
                VStack(alignment: .leading) {
                    Text(mode.title + (isPlusMode ? "+" : ""))
                        .font(.title)
                        .foregroundStyle(mode.gaugeColor)
                        .animation(.default, value: isPlusMode)
                        .contentTransition(.numericText())
                    
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
