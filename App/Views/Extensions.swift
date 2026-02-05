import SwiftUI

extension View {
    func makeTopInset() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .clipped()
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .addShadow(opacity: 0.25)
            .padding(.bottom)
            .padding(.horizontal)
    }
    
    func addShadow(opacity: Double = 1) -> some View {
        ShadowWrapper(opacity: opacity) {
            self
        }
    }
}

private struct ShadowWrapper<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    let opacity: Double
    let content: () -> Content
    
    var body: some View {
        content()
            .shadow(color: colorScheme == .light ? .black.opacity(opacity) : .white.opacity(opacity), radius: 1)
    }
}

extension Color {
    func makeLabel(title: String, isSmall: Bool = false) -> some View {
        RoundedRectangle(cornerRadius: isSmall ? 20 : 40)
            .foregroundStyle(self)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: isSmall ? 20 : 40))
            .addShadow()
            .overlay {
                Text(title)
                    .font(isSmall ? .body : .title3)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(isSmall ? 5 : 10)
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular.interactive())
                    .padding(isSmall ? 10 : 15)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
    }
}

extension Gradient {
    static let hue =
        Gradient(colors: stride(from: 0, to: 1, by: 0.01).map {
            Color(hue: $0, saturation: 1, brightness: 1)
        })
}

extension Game {
    func makeScoreToActualColorSection(title: String, you: Double, me: Double) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .padding(.top, 5)
                .padding(.vertical, 5)
            
            VStack(alignment: .leading, spacing: 0) {
                you.makeGaugeLabel(title: "You: ")
                
                me.makeGaugeLabel(title: "Me: ")
            }
            .padding(.horizontal)
        }
    }
}

extension Double {
    func makeGaugeLabel(title: String) -> some View {
        HStack {
            HStack {
                Text(title)
                
                Text(self.formatted(percentFormat))
                    .bold()
                    .contentTransition(.numericText())
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .containerRelativeFrame(.horizontal) { length, _ in
                length * (1 / 4)
            }
            
            Gauge(value: self) {
                Text("")
            }
            .gaugeStyle(.accessoryLinear)
        }
    }
}

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
                HStack(spacing: 0) {
                    Text("Name: ")
                        .bold()
                    
                    Text(question.name)
                        .foregroundStyle(question.isAnswered ? question.answer : colorScheme == .light ? .black : .white)
                        .font(isSmall ? .title2 : .title)
                        .bold()
                        .contentTransition(.numericText())
                }
                .frame(maxWidth: .infinity, alignment: question.isAnswered ? .leading : .center)
              
                if question.isAnswered {
                    HStack(alignment: .bottom, spacing: 0) {
                        Text(game.isPlusMode ? "Score to my guess: " : "Score: ")
                            .padding(.top, 3)
                        
                        Text((game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer).formatted(percentFormat))
                            .bold()
                            .contentTransition(.numericText())
                     }
                    .padding(.top, 3)
                    .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .scale(scale: 0, anchor: .top)),
                                            removal: .move(edge: .top).combined(with: .scale(scale: 0, anchor: .top))))
                }
                
                Text((game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer).formatted(percentFormat))
                    .opacity(0.0)
                    .frame(height: 0.0)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Spacer()
            
            if question.isAnswered {
                Gauge(value: game.isPlusMode ? question.scoreToMyAnswer : question.scoreToCorrectAnswer) {
                    Text("")
                }
                .tint(question.answer)
                .gaugeStyle(.accessoryCircular)
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                        removal: .move(edge: .trailing).combined(with: .opacity)))
            }
        }
        .padding(question.isAnswered && hasGlassEffect ? 10 : 0)
        .frame(maxWidth: .infinity)
        .glassEffect(question.isAnswered && hasGlassEffect ? .regular.interactive() : .identity, in: RoundedRectangle(cornerRadius: 20))
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
