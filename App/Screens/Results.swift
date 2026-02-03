import SwiftUI

struct Results: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Game.self) var game
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(game.questions.enumerated(), id: \.offset) { index, question in
                    VStack {
                        HStack {
                            HStack(spacing: 0) {
                                Text("Name: ")
                                    .bold()
                                
                                Text(question.name)
                                    .foregroundStyle(question.answer)
                                    .font(.title)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity)
                            .glassEffect(.regular.interactive())
                        }
                        
                        
                        HStack(alignment: .center) {
                            HStack(spacing: 0) {
                                Text("Score: ")
                                    .bold()
                                
                                Text(question.scoreToMyAnswer.formatted(decimalFormat))
                                    .font(.title3)
                            }
                            
                            Gauge(value: question.scoreToMyAnswer) {
                                Text("")
                            }
                            .tint(question.answer)
                            .gaugeStyle(.accessoryLinear)
                            .glassEffect(.regular.interactive())
                        }
                        .padding(.vertical, 3)
                        
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
                    .glassEffect(.regular.interactive())
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
