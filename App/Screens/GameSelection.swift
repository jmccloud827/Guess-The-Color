import SwiftUI

struct GameSelection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var game: Game? = nil
    @State private var isPlusMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(Difficulty.allCases, id: \.hashValue) { difficulty in
                    DifficultyButton(game: $game, difficulty: difficulty, isPlusMode: isPlusMode)
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
        .makeBottomInsetButton {
            isPlusMode.toggle()
        }
    }
}

private struct DifficultyButton: View {
    @Binding var game: Game?
    
    let difficulty: Difficulty
    let isPlusMode: Bool
    
    var body: some View {
        Button {
            game = .init(difficulty: difficulty, isPlusMode: isPlusMode)
        } label: {
            HStack {
                Gauge(value: isPlusMode ? difficulty.gaugeValue / 2 + 0.5 : difficulty.gaugeValue / 2) {
                    Text("")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(difficulty.gaugeColor.gradient)
                .padding(.trailing)
                .animation(.default, value: isPlusMode)
                
                VStack(alignment: .leading) {
                    Text(difficulty.title + (isPlusMode ? "+" : ""))
                        .font(.title)
                        .foregroundStyle(difficulty.gaugeColor)
                        .animation(.default, value: isPlusMode)
                        .contentTransition(.numericText())
                    
                    Text(difficulty.description)
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
