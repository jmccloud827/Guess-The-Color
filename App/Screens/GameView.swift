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
            .safeAreaInset(edge: .bottom) {
                if !game.isComplete {
                    bottomButton
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
                        .foregroundStyle(LinearGradient(gradient: hueGradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                }
            }
        }
    }
    
    private var bottomButton: some View {
        Text(game.isComplete ? "Done" : game.currentQuestion.isAnswered ? "Next Question" : "Guess")
            .font(.title2)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .contentTransition(.numericText())
            .background {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundStyle(.bar)
            }
            .glassEffect(.regular.interactive())
            .shadow(color: colorScheme == .light ? .black.opacity(0.25) : .white.opacity(0.25), radius: 1)
            .padding(.top)
            .padding(.horizontal)
            .onTapGesture {
                if game.currentQuestion.isAnswered {
                    withAnimation(.default) {
                        game.nextQuestion()
                    }
                        
                    if game.isComplete {
                        withAnimation(.easeOut(duration: 0.5).delay(0.75)) {
                            game.calculateAverageScores()
                        }
                    }
                } else {
                    withAnimation(.default) {
                        game.currentQuestion.isAnswered = true
                    }
                        
                    withAnimation(.easeOut(duration: 0.5).delay(0.75)) {
                        game.currentQuestion.calculateScores()
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
