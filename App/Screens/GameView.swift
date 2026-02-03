import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    
    let game: Game
    
    var body: some View {
        NavigationStack {
            ZStack {
                QuestionView(question: game.currentQuestion)
                    .offset(x: game.isComplete ? -UIScreen.main.bounds.width : 0)
                
                Results()
                    .offset(x: game.isComplete ? 0 : UIScreen.main.bounds.width)
            }
            .safeAreaInset(edge: .top) {
                topView
            }
            .safeAreaInset(edge: .bottom) {
                bottomButton
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
    
    private var topView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(game.isComplete ? "Average Score: " : "Name: ")
                        .bold()
                        
                    Text(game.isComplete ? game.averageScoreToMyAnswer.formatted(decimalFormat) : game.currentQuestion.name)
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .contentTransition(.numericText())
                }
                
                HStack {
                    Text("\(game.isPlusMode ? "Score to my guess" : "Score"): ")
                        .bold()
                        
                    Text((game.isPlusMode ? game.currentQuestion.scoreToMyAnswer : game.currentQuestion.scoreToCorrectAnswer).formatted(decimalFormat))
                        .contentTransition(.numericText())
                        .font(.title3)
                        .bold()
                        .minimumScaleFactor(0.7)
                }
                .frame(height: game.isComplete || !game.currentQuestion.isAnswered ? 0 : nil)
                .offset(x: game.isComplete || !game.currentQuestion.isAnswered ? -100 : 0)
                .clipped()
                
                if game.isPlusMode {
                    HStack {
                        Text("My Average Score: ")
                            .bold()
                        
                        Text(game.myAverageScoreToCorrectAnswer.formatted(decimalFormat))
                            .contentTransition(.numericText())
                            .font(.title3)
                            .bold()
                            .minimumScaleFactor(0.7)
                    }
                    .frame(height: !game.isComplete ? 0 : nil)
                    .offset(x: !game.isComplete ? -100 : 0)
                    .clipped()
                }
            }
            .padding(.vertical)
            
            if game.currentQuestion.isAnswered || game.isComplete {
                Spacer()
            }
                
            Group {
                if game.isComplete {
                    Gauge(value: game.averageScoreToMyAnswer) {
                        Text("")
                    }
                    .tint(hueGradient)
                    .padding(.vertical)
                } else {
                    Gauge(value: game.currentQuestion.myScoreToCorrectAnswer) {
                        Text("")
                    }
                    .tint(game.currentQuestion.answer)
                    .frame(width: game.currentQuestion.isAnswered ? nil : 0)
                    .offset(x: game.currentQuestion.isAnswered ? 0 : 100)
                    .clipped()
                }
            }
            .gaugeStyle(.accessoryCircular)
            .scaleEffect(0.9)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .padding(.bottom)
        .padding(.horizontal)
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
            .padding(.top)
            .padding(.horizontal)
            .onTapGesture {
                if game.isComplete {
                    dismiss()
                } else {
                    if game.currentQuestion.isAnswered {
                        withAnimation {
                            game.nextQuestion()
                        } completion: {
                            if game.isComplete {
                                withAnimation {
                                    game.calculateAverageScores()
                                }
                            }
                        }
                    } else {
                        withAnimation {
                            game.currentQuestion.isAnswered = true
                        } completion: {
                            withAnimation {
                                game.currentQuestion.calculateScores()
                            }
                        }
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
