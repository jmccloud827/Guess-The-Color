import SwiftUI

struct QuestionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Game.self) var game
    
    @Bindable var question: Question
    
    @State private var isDisclosureGroupOpen = true
    
    var body: some View {
        ZStack {
            questionView
                .offset(y: question.isAnswered ? -UIScreen.main.bounds.height : 0)
            
            resultsView
                .offset(y: question.isAnswered ? 0 : UIScreen.main.bounds.height)
        }
        .padding(.horizontal)
    }
    
    private var questionView: some View {
        VStack {
            ColorPicker(color: $question.guess)
        }
    }
    
    private var resultsView: some View {
        VStack(spacing: 10) {
            if game.isPlusMode {
                makeColorLabel(for: question.guess, title: "Your Guess", score: nil, scoreTitle: nil)
                
                makeColorLabel(for: question.myAnswer, title: "My Answer", score: question.myScoreToCorrectAnswer, scoreTitle: "My score to correct color")
                
                DisclosureGroup(isExpanded: $isDisclosureGroupOpen) {
                    VStack(alignment: .leading) {
                        Text(question.notes)
                    }
                } label: {
                    Text("My thoughts/notes: ")
                        .font(.title3)
                }
                .padding()
                .tint(ForegroundStyle.foreground)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
                
                makeColorLabel(for: question.answer, title: "Actual Color", score: question.scoreToCorrectAnswer, scoreTitle: "Your score to correct color")
            } else {
                makeColorLabel(for: question.guess, title: "Your Guess", score: nil, scoreTitle: nil)
                
                makeColorLabel(for: question.answer, title: "Answer", score: nil, scoreTitle: nil)
            }
        }
    }
    
    private func makeColorLabel(for color: Color, title: String, score: Double?, scoreTitle: String?) -> some View {
        RoundedRectangle(cornerRadius: 40)
            .foregroundStyle(color)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 40))
            .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title3)
                            .bold()
                        
                        if let score, let scoreTitle {
                            HStack(spacing: 0) {
                                Text("\(scoreTitle): ")
                                    .bold()
                                
                                Text(score.formatted(decimalFormat))
                                    .contentTransition(.numericText())
                                    .bold()
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        }
                    }
                    
                    if let score {
                        Spacer()
                        
                        Gauge(value: score) {
                            Text("")
                        }
                        .gaugeStyle(.accessoryCircular)
                        .tint(color)
                        .scaleEffect(0.75)
                        .frame(height: 45)
                        .clipped()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 25))
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
