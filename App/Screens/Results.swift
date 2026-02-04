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
                            VStack(alignment: .leading) {
                                HStack(spacing: 0) {
                                    Text("Name: ")
                                        .bold()
                                    
                                    Text(question.name)
                                        .foregroundStyle(question.answer)
                                        .font(.title2)
                                        .bold()
                                }
                                
                                HStack(spacing: 0) {
                                    Text(game.isPlusMode ? "Score to my guess: " : "Score: ")
                                        
                                    Text((game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer).formatted(decimalFormat))
                                        .bold()
                                        .contentTransition(.numericText())
                                }
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            
                            Spacer()
                            
                            Gauge(value: game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer) {
                                Text("")
                            }
                            .tint(question.answer)
                            .gaugeStyle(.accessoryCircular)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
                        .padding(.bottom, 5)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                if game.isPlusMode {
                                    Text("Score to actual color: ")
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Text("You: \(question.scoreToCorrectAnswer.formatted(decimalFormat))")
                                                
                                            Gauge(value: question.scoreToCorrectAnswer) {
                                                Text("")
                                            }
                                            .tint(colorScheme == .light ? .black : .white)
                                            .gaugeStyle(.accessoryLinear)
                                        }
                                            
                                        HStack {
                                            Text("Me: \(question.myScoreToCorrectAnswer.formatted(decimalFormat))")
                                                
                                            Gauge(value: question.myScoreToCorrectAnswer) {
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
                                makeColorLabel(for: question.myAnswer, title: "My Guess")
                            }
                            
                            makeColorLabel(for: question.answer, title: game.isPlusMode ? "Actual Color" : "Answer")
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
                    .glassEffect(.regular.interactive())
                    .padding(10)
                    .frame(maxHeight: .infinity, alignment: .bottom)
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
