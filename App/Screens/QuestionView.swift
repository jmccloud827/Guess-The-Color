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
            
            answerView
                .offset(y: question.isAnswered ? 0 : UIScreen.main.bounds.height)
        }
        .padding(.horizontal)
        .safeAreaInset(edge: .top) {
            topInset
        }
        .safeAreaInset(edge: .bottom) {
            bottomButton
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
    }
    
    private var topInset: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                question.makeScoreLabel(hasGlassEffect: game.isPlusMode)
                
                if game.isPlusMode {
                    game.makeScoreToActualColorSection(title: "Score to actual color: ", you: question.scoreToCorrectAnswer, me: question.myScoreToCorrectAnswer)
                        .frame(height: !question.isAnswered ? 0 : nil)
                        .offset(x: !question.isAnswered ? -100 : 0)
                        .clipped()
                }
            }
            .padding(.vertical)
        }
        .makeTopInset()
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
            .addShadow(opacity: 0.25)
            .padding(.top)
            .padding(.horizontal)
            .onTapGesture {
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

#Preview("Regular") {
    let game = Game(mode: .hard, isPlusMode: false)
    
    return GameView(game: game)
}

#Preview("Plus Mode") {
    let game = Game(mode: .hard, isPlusMode: true)
    
    return GameView(game: game)
}
