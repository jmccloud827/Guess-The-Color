import SwiftUI

struct Results: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Game.self) var game
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(game.questions.enumerated(), id: \.offset) { _, question in
                    VStack {
                        HStack {
                            HStack(spacing: 0) {
                                Text("Name: ")
                                    .bold()
                                
                                Text(question.name)
                                    .foregroundStyle(question.answer)
                                    .font(.title2)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity)
                            .glassEffect(.regular.interactive())
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(game.isPlusMode ? "Score to my guess: " : "Score: ")
                                            .bold()
                                        
                                        Spacer()
                                            
                                        Text(question.scoreToMyAnswer.formatted(decimalFormat))
                                            .font(.title)
                                            .bold()
                                            .contentTransition(.numericText())
                                    }
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    
                                    Gauge(value: game.averageScoreToMyAnswer) {
                                        Text("")
                                    }
                                    .tint(question.answer)
                                    .gaugeStyle(.accessoryLinear)
                                    .padding(.top, 5)
                                }
                                
                                if game.isPlusMode {
                                    Text("Average score to correct color: ")
                                        .padding(.top, 5)
                                        .padding(.vertical, 5)
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("You: \(game.averageScoreToCorrectAnswer.formatted(decimalFormat))")
                                                
                                            Gauge(value: game.averageScoreToCorrectAnswer) {
                                                Text("")
                                            }
                                            .tint(colorScheme == .light ? .black : .white)
                                            .gaugeStyle(.accessoryLinear)
                                        }
                                            
                                        HStack {
                                            Text("Me: \(game.myAverageScoreToCorrectAnswer.formatted(decimalFormat))")
                                                
                                            Gauge(value: game.myAverageScoreToCorrectAnswer) {
                                                Text("")
                                            }
                                            .tint(colorScheme == .light ? .black : .white)
                                            .gaugeStyle(.accessoryLinear)
                                        }
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            makeColorLabel(for: question.guess, title: game.isPlusMode ? "Your Guess" : "Guess")
                            
                            if game.isPlusMode {
                                makeColorLabel(for: question.myAnswer, title: "My Answer")
                            }
                            
                            makeColorLabel(for: question.answer, title: game.isPlusMode ? "Correct Color" : "Answer")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 20)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
                    .shadow(color: colorScheme == .light ? .black.opacity(0.25) : .white.opacity(0.25), radius: 1)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func makeColorLabel(for color: Color, title: String) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(color)
            .frame(height: 100)
            .overlay {
                Text(title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview("Reguar") {
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
