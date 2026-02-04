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
                VStack(spacing: 0) {
                    Group {
                        HStack {
                            Text("Name: ")
                                .bold()
                            
                            Text(game.currentQuestion.name)
                                .font(.title)
                                .bold()
                                .contentTransition(.numericText())
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: game.currentQuestion.isAnswered && !game.isPlusMode ? .leading : .center)
                        .frame(height: game.isComplete ? 0 : nil)
                        .offset(y: game.isComplete ? -100 : 0)
                        .clipped()
                        
                        Group {
                            if game.isPlusMode {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Average score to my guess: ")
                                            .bold()
                                        
                                        Text(game.averageScoreToMyAnswer.formatted(decimalFormat))
                                            .font(.title)
                                            .bold()
                                            .contentTransition(.numericText())
                                    }
                                    
                                    Gauge(value: game.averageScoreToMyAnswer) {
                                        Text("")
                                    }
                                    .tint(hueGradient)
                                    .gaugeStyle(.accessoryLinear)
                                }
                            } else {
                                VStack(spacing: 0) {
                                    HStack {
                                        Text("Score: ")
                                            .bold()
                                        
                                        Text(game.averageScoreToCorrectAnswer.formatted(decimalFormat))
                                            .font(.title)
                                            .bold()
                                            .contentTransition(.numericText())
                                    }
                                    
                                    Gauge(value: game.averageScoreToCorrectAnswer) {
                                        Text("")
                                    }
                                    .tint(hueGradient)
                                    .gaugeStyle(.accessoryLinear)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: game.isComplete ? .leading : .center)
                        .frame(height: !game.isComplete ? 0 : nil)
                        .offset(x: !game.isComplete ? -100 : 0)
                        .clipped()
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
                
                if !game.isPlusMode {
                    HStack {
                        Text("Score: ")
                            .bold()
                        
                        Text(game.currentQuestion.scoreToCorrectAnswer.formatted(decimalFormat))
                            .contentTransition(.numericText())
                            .font(.title3)
                            .bold()
                            .minimumScaleFactor(0.7)
                    }
                    .frame(height: game.isComplete || !game.currentQuestion.isAnswered ? 0 : nil)
                    .offset(y: game.isComplete || !game.currentQuestion.isAnswered ? 100 : 0)
                    .clipped()
                }
                
                if game.isPlusMode {
                    Text("Average score to actual color: ")
                        .padding(.top, 5)
                        .padding(.vertical, 5)
                        .frame(height: game.isComplete ? nil : 0)
                        .offset(x: game.isComplete ? 0 : -100)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            HStack {
                                Text("You: ")
                                
                                Text(game.averageScoreToCorrectAnswer.formatted(decimalFormat))
                                    .bold()
                                    .contentTransition(.numericText())
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                                
                            Gauge(value: game.averageScoreToCorrectAnswer) {
                                Text("")
                            }
                            .tint(colorScheme == .light ? .black : .white)
                            .gaugeStyle(.accessoryLinear)
                        }
                        .frame(width: game.isComplete ? nil : 0, height: game.isComplete ? nil : 0)
                        .offset(x: game.isComplete ? 0 : -100)
                        .clipped()
                            
                        HStack {
                            HStack {
                                Text("Me: ")
                                
                                Text(game.myAverageScoreToCorrectAnswer.formatted(decimalFormat))
                                    .bold()
                                    .contentTransition(.numericText())
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                                
                            Gauge(value: game.myAverageScoreToCorrectAnswer) {
                                Text("")
                            }
                            .tint(colorScheme == .light ? .black : .white)
                            .gaugeStyle(.accessoryLinear)
                        }
                        .frame(width: game.isComplete ? nil : 0, height: game.isComplete ? nil : 0)
                        .offset(x: game.isComplete ? 0 : -100)
                        .clipped()
                    }
                }
            }
            .padding(.vertical)
                
            Group {
                if !game.isComplete && !game.isPlusMode {
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
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: colorScheme == .light ? .black.opacity(0.25) : .white.opacity(0.25), radius: 1)
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
            .shadow(color: colorScheme == .light ? .black.opacity(0.25) : .white.opacity(0.25), radius: 1)
            .padding(.top)
            .padding(.horizontal)
            .onTapGesture {
                if game.isComplete {
                    dismiss()
                } else {
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
}

#Preview("Regular") {
    let game = Game(mode: .hard, isPlusMode: false)
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(mode: .hard, isPlusMode: true)
    
    return GameView(game: game)
}
