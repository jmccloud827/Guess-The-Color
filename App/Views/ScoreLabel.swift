import SwiftUI

extension Question {
    func makeScoreLabel(isSmall: Bool = false, hasGlassEffect: Bool = true) -> some View {
        ScoreLabelWrapper(question: self, isSmall: isSmall, hasGlassEffect: hasGlassEffect)
    }
}

private struct ScoreLabelWrapper: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Environment(Game.self) private var game
    
    let question: Question
    let isSmall: Bool
    let hasGlassEffect: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                questionLabel
              
                if question.isAnswered {
                    scoreLabel
                }
                
                hiddenScoreText
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Spacer()
            
            if question.isAnswered {
                gauge
            }
        }
        .padding(question.isAnswered && hasGlassEffect ? 10 : 0)
        .frame(maxWidth: .infinity)
        .glassEffect(question.isAnswered && hasGlassEffect ? .regular.interactive() : .identity, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private var questionLabel: some View {
        HStack(spacing: 5) {
            Text("Name: ")
                .bold()
            
            Text(question.name)
                .foregroundStyle(question.isAnswered ? question.answer : colorScheme == .light ? .black : .white)
                .font(isSmall ? .title2 : .title)
                .bold()
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: question.isAnswered ? .leading : .center)
    }
    
    private var scoreLabel: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(game.isPlusMode ? "Score to my guess: " : "Score: ")
                .padding(.top, 3)
            
            Text((game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer).formatted(.roundedPercent))
                .bold()
                .contentTransition(.numericText())
        }
        .padding(.top, 3)
        .transition(.blurReplace.combined(with: .scale(0, anchor: .leading)))
    }
    
    // Animation breaks if there is no value on screen. This is my dirty work around
    private var hiddenScoreText: some View {
        Text((game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer).formatted(.roundedPercent))
            .opacity(0.0)
            .frame(height: 0.0)
    }
    
    private var gauge: some View {
        Gauge(value: game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer) {
            Text("")
        }
        .tint(question.answer)
        .gaugeStyle(.accessoryCircular)
        .transition(.move(edge: .top).combined(with: .scale).combined(with: .opacity))
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
