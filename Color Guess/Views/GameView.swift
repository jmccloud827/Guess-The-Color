import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    
    let game: Game
    
    var body: some View {
        NavigationStack {
            Group {
                if let question = game.currentQuestion {
                    QuestionView(question: question)
                } else {
                    Text("Game is over")
                }
            }
            .environment(game)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(game.mode.title)
                        .font(.title)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: self.makeHueColors(stepSize: 0.01)), startPoint: .leading, endPoint: .trailing))
                }
            }
        }
    }
    
    private func makeHueColors(stepSize _: Double) -> [Color] {
        stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        }
    }
}

#Preview {
    GameView(game: .init(mode: .impossible))
}
