import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    let game: Game
    
    var body: some View {
        NavigationStack {
            ZStack {
                QuestionView(question: game.currentQuestion)
                    .offset(x: game.isComplete ? -UIScreen.main.bounds.width : 0)
                
                Results()
                    .offset(x: game.isComplete ? 0 : UIScreen.main.bounds.width)
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
                        .foregroundStyle(LinearGradient(gradient: .hue, startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            }
        }
    }
}

#Preview("Regular") {
    let game = Game(mode: .hard, isPlusMode: false)
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(mode: .hard, isPlusMode: true)
    
    return GameView(game: game)
}
