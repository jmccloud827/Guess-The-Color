import SwiftUI

struct GameSelection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var game: Game? = nil
    @State private var isPlusMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(Game.Mode.allCases, id: \.hashValue) { mode in
                    makeDifficultyLabel(for: mode)
                }
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .fullScreenCover(item: $game) { game in
            GameView(game: game)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Guess the Color")
                    .font(.title)
                    .foregroundStyle(LinearGradient(gradient: .hue, startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
        .safeAreaInset(edge: .bottom) {
            plusModeToggle
        }
    }
    
    private var plusModeToggle: some View {
        Button {
            isPlusMode.toggle()
        } label: {
            Toggle(isOn: $isPlusMode) {
                VStack(alignment: .leading) {
                    Text("+ Mode")
                        .font(.title2)
                    
                    Text("Questions stay the same but the answers are my guesses... and I'm colorblind😈.")
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
    
    private func makeDifficultyLabel(for mode: Game.Mode) -> some View {
        Button {
            game = .init(mode: mode, isPlusMode: isPlusMode)
        } label: {
            HStack {
                Gauge(value: isPlusMode ? mode.gaugeValue / 2 + 0.5 : mode.gaugeValue / 2) {
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
            .addShadow(opacity: 0.25)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        GameSelection()
    }
}
