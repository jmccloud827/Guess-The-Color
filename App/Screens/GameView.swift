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
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(game.questions.enumerated(), id: \.offset) { index, question in
                                VStack(alignment: .leading) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Question: \(index + 1)")
                                                .font(.title)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack(spacing: 0) {
                                                Text("Name: ")
                                                Text(question.name)
                                                    .foregroundStyle(question.answer)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        Spacer()
                                        
                                        Gauge(value: (question.result ?? 0)) {
                                            Text("Score: \((question.result ?? 0).formatted(.percent.precision(.significantDigits(3)).rounded(rule: .up)))")
                                        }
                                        .tint(question.answer)
                                    }
                                    
                                    HStack {
                                        Text("Guess: ")
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(question.guess)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 20)
                                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .safeAreaInset(edge: .top) {
                        HStack {
                            Text("Average Score: ")
                                .bold()
                                
                            Text(game.averageOfAnsweredQuestions().formatted(.percent.precision(.significantDigits(3)).rounded(rule: .up)))
                                .font(.title)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .glassEffect()
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
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

#Preview("Start") {
    let game = Game(mode: .hard, isPlusMode: true)
    
    return GameView(game: game)
}

#Preview("End") {
    let game = Game(mode: .hard, isPlusMode: true)
    game.questions.forEach { $0.commitAnswer(); $0.calculateResult(); game.nextQuestion() }
    
    return GameView(game: game)
}
