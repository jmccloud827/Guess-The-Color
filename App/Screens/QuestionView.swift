import SwiftUI

struct QuestionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Game.self) var game
    
    @Bindable var question: Question
    
    var body: some View {
        ZStack {
            questionView
                .offset(y: question.result != nil ? -UIScreen.main.bounds.height : 0)
            
            resultsView
                .offset(y: question.result != nil ? 0 : UIScreen.main.bounds.height)
        }
        .safeAreaInset(edge: .top) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Name: ")
                            .bold()
                        
                        Text(question.name)
                            .font(.title)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .contentTransition(.numericText())
                    }
                    .padding(.trailing)
                    
                    HStack {
                        Text("Score: ")
                            .bold()
                        
                        Text((question.result ?? 0).formatted(.percent.precision(.significantDigits(3)).rounded(rule: .up)))
                            .contentTransition(.numericText())
                            .font(.title3)
                            .bold()
                            .minimumScaleFactor(0.7)
                    }
                    .frame(height: question.result == nil ? 0 : nil)
                    .offset(x: question.result == nil ? -100 : 0)
                    .clipped()
                }
                .padding(.vertical)
                
                if question.result != nil {
                    Spacer()
                }
                
                Gauge(value: (question.result ?? 0)) {
                    Text("")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(question.answer)
                .scaleEffect(0.9)
                .frame(width: question.result == nil ? 0 : nil)
                .offset(x: question.result == nil ? 100 : 0)
                .clipped()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.bottom)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                withAnimation {
                    if question.result == nil {
                        question.commitAnswer()
                    } else {
                        game.nextQuestion()
                    }
                } completion: {
                    withAnimation {
                        if question.result != nil {
                            question.calculateResult()
                        }
                    }
                }
            } label: {
                Text(question.result == nil ? "Guess" : "Next Question")
                    .font(.title2)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .contentTransition(.numericText())
            }
            .buttonStyle(.glass)
            .padding(.top)
        }
        .padding(.horizontal)
    }
    
    private var questionView: some View {
        VStack {
            ColorPicker3(color: $question.guess)
        }
    }
    
    private var resultsView: some View {
        VStack(spacing: 10) {
            if let myAnswer = question.myAnswer {
                makeColorLabel(for: question.guess, title: "Your Guess")
                
                makeColorLabel(for: myAnswer, title: "My Answer")
                
                if let notes = question.notes {
                    Text("My reasoning: " + notes)
                        .padding()
                }
                
                makeColorLabel(for: question.answer, title: "Actual Color")
            } else {
                makeColorLabel(for: question.guess, title: "Your Guess")
                
                makeColorLabel(for: question.answer, title: "Answer")
            }
        }
    }
    
    private func makeColorLabel(for color: Color, title: String) -> some View {
        RoundedRectangle(cornerRadius: 40)
            .foregroundStyle(color)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 40))
            .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
            .overlay {
                Text(title)
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular.interactive())
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
    }
}

#Preview("Regular") {
    let game = Game(mode: .hard, isPlusMode: false)
    guard let question = game.currentQuestion else {
        return EmptyView()
    }
    
    return NavigationStack {
        QuestionView(question: question)
            .environment(game)
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Plus Mode") {
    let game = Game(mode: .hard, isPlusMode: true)
    guard let question = game.currentQuestion else {
        return EmptyView()
    }
    
    return NavigationStack {
        QuestionView(question: question)
            .environment(game)
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
    }
}
