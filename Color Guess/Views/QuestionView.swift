import SwiftUI

struct QuestionView: View {
    @Environment(Game.self) var game
    @Bindable var question: Question
    
    var body: some View {
        ZStack {
            questionView
                .offset(y: question.result != nil ? -UIScreen.main.bounds.height : 0)
            
            resultsView
                .offset(y: question.result != nil ? 0 : UIScreen.main.bounds.height)
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
        }
        .padding(.horizontal)
    }
    
    private var questionView: some View {
        VStack {
            HStack {
                Text("Name: ")
                    .bold()
                
                Text(question.name)
                    .font(.title)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .glassEffect()
            
            Spacer()
            
            ColorPicker("Guess", selection: $question.guess)
            
            Spacer()
        }
    }
    
    private var resultsView: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Score: ")
                    .bold()
                
                Text((question.result ?? 0).formatted(.percent.precision(.significantDigits(3)).rounded(rule: .up)))
                    .contentTransition(.numericText())
                    .font(.title)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .glassEffect()
            
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
        .padding(.bottom)
    }
    
    private func makeColorLabel(for color: Color, title: String) -> some View {
        RoundedRectangle(cornerRadius: 40)
            .foregroundStyle(color)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 40))
            .shadow(color: .white, radius: 1)
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

#Preview {
    guard let color = Game.impossibleColors.first else {
        return EmptyView()
    }
    let question = Question(model: color)
    question.commitAnswer()
    
    return NavigationStack {
        QuestionView(question: question)
            .environment(Game(mode: .impossible))
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
    }
}
