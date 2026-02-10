import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    let game: Game
    
    var body: some View {
        NavigationStack {
            ZStack {
                QuestionView(question: game.currentQuestion)
                    .offset(x: game.isComplete ? -screenSize.width : 0)
                
                Results()
                    .offset(x: game.isComplete ? 0 : screenSize.width)
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
                    Text(game.difficulty.title)
                        .font(.title)
                        .foregroundStyle(LinearGradient(gradient: .hue, startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            }
        }
    }
}

#Preview("Regular") {
    let game = Game(difficulty: .hard, isPlusMode: false)
    game.questions.prefix(11).forEach { $0.isAnswered = true; $0.calculateScores(); game.nextQuestion() }
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(difficulty: .hard, isPlusMode: true)
    game.questions.prefix(11).forEach { $0.isAnswered = true; $0.calculateScores(); game.nextQuestion() }
    
    return GameView(game: game)
}
