import SwiftUI

struct Results: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Game.self) var game
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(game.questions.enumerated(), id: \.offset) { _, question in
                    makeSection(for: question)
                }
            }
            .padding(.horizontal)
        }
        .safeAreaInset(edge: .top) {
            topInset
        }
    }
    
    private var topInset: some View {
        VStack(spacing: 0) {
            if game.isPlusMode {
                makeAverageScoreLabel(title: "Average score to my guess: ", score: game.averageScoreToMyAnswer)
                .padding()
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
            } else {
                makeAverageScoreLabel(title: "Average score: ", score: game.averageScoreToCorrectAnswer)
            }
            
            if game.isPlusMode {
                game.makeScoreToActualColorSection(title: "Average score to actual color: ", you: game.averageScoreToCorrectAnswer, me: game.myAverageScoreToCorrectAnswer)
            }
        }
        .padding(.vertical)
        .makeTopInset()
    }
    
    private func makeSection(for question: Question) -> some View {
        VStack(spacing: 10) {
            question.makeScoreLabel(isSmall: true)
            
            if game.isPlusMode {
                game.makeScoreToActualColorSection(title: "Score to actual color: ", you: question.scoreToCorrectAnswer, me: question.myScoreToCorrectAnswer)
            }
            
            HStack {
                question.guess.makeLabel(title: game.isPlusMode ? "Your Guess" : "Guess", isSmall: true)
                
                if game.isPlusMode {
                    question.myAnswer.makeLabel(title: "My Guess", isSmall: true)
                }
                
                question.answer.makeLabel(title: game.isPlusMode ? "Actual Color" : "Answer", isSmall: true)
            }
            .frame(height: 100)
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
        .addShadow(opacity: 0.25)
    }
    
    private func makeAverageScoreLabel(title: String, score: Double) -> some View {
        VStack(spacing: 10) {
            HStack {
                Text(title)
                    .bold()
                    
                Text(score.formatted(percentFormat))
                    .font(.title)
                    .bold()
                    .contentTransition(.numericText())
            }
                
            Gauge(value: score) {
                Text("")
            }
            .tint(Gradient.hue)
            .gaugeStyle(.accessoryLinear)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.9)
    }
}

#Preview("Regular") {
    let game = Game(mode: .hard, isPlusMode: false)
    game.questions.forEach { $0.isAnswered = true; $0.calculateScores(); game.nextQuestion() }
    game.calculateAverageScores()
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(mode: .hard, isPlusMode: true)
    game.questions.forEach { $0.isAnswered = true; $0.calculateScores(); game.nextQuestion() }
    game.calculateAverageScores()
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(mode: .hard, isPlusMode: true)
    game.questions.forEach { $0.isAnswered = true; $0.calculateScores(); game.nextQuestion() }
    game.calculateAverageScores()
    
    return GameView2(game: game)
}
