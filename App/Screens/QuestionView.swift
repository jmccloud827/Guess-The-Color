import SwiftUI

struct QuestionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Game.self) var game
    
    @Bindable var question: Question
    
    @State private var isDisclosureGroupOpen = true
    @State private var isButtonDisabled = false
    
    var body: some View {
        ZStack {
            if !question.isAnswered {
                questionView
                    .transition(.move(edge: .leading))
            }
            
            if question.isAnswered {
                answerView
                    .transition(.move(edge: .trailing))
            }
        }
        .safeAreaInset(edge: .top) {
            topInset
        }
        .safeAreaInset(edge: .bottom) {
            bottomButton
                .disabled(isButtonDisabled)
        }
    }
    
    private var questionView: some View {
        ColorPicker(color: $question.guess)
    }
    
    private var answerView: some View {
        VStack(spacing: 10) {
            if game.isPlusMode {
                question.myAnswer.makeLabel(title: "My Guess")
                
                question.guess.makeLabel(title: "Your Guess")
                
                DisclosureGroup(isExpanded: $isDisclosureGroupOpen) {
                    Text(.init(question.notes))
                        .frame(maxWidth: .infinity, alignment: .leading)
                } label: {
                    Text("My thoughts/notes: ")
                        .font(.title3)
                }
                .padding()
                .tint(ForegroundStyle.foreground)
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30))
                
                question.answer.makeLabel(title: "Actual Color")
            } else {
                question.guess.makeLabel(title: "Your Guess")
                
                question.answer.makeLabel(title: "Answer")
            }
        }
        .padding(.horizontal)
    }
    
    private var topInset: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                question.makeScoreLabel(hasGlassEffect: game.isPlusMode)
                
                if game.isPlusMode && question.isAnswered {
                    game.makeScoreToActualColorSection(title: "Score to actual color: ", you: question.scoreToCorrectAnswer, me: question.myScoreToCorrectAnswer)
                        .transition(.blurReplace.combined(with: .scale(0, anchor: .leading)))
                }
            }
            .padding(.vertical)
        }
        .makeTopInset()
    }
    
    private var bottomButton: some View {
        Text(game.isComplete ? "Done" : game.currentQuestion.isAnswered ? "Next Question" : "Guess")
            .font(.title2)
            .contentTransition(.numericText())
            .makeBottomInsetButton {
                isButtonDisabled = true
                if game.currentQuestion.isAnswered {
                    withAnimation {
                        game.nextQuestion()
                    } completion: {
                        isButtonDisabled = false
                    }
                        
                    if game.isComplete {
                        withAnimation(.easeOut(duration: 0.5).delay(0.75)) {
                            game.calculateAverageScores()
                        }
                    }
                } else {
                    withAnimation {
                        game.currentQuestion.isAnswered = true
                    } completion: {
                        isButtonDisabled = false
                    }
                        
                    withAnimation(.easeOut(duration: 0.5).delay(0.75)) {
                        game.currentQuestion.calculateScores()
                    }
                }
            }
    }
}

#Preview("Regular") {
    let game = Game(difficulty: .hard, isPlusMode: false)
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(difficulty: .hard, isPlusMode: true)
    
    return GameView(game: game)
}
