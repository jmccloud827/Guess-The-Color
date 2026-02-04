import SwiftUI

struct QuestionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(Game.self) var game
    
    @Bindable var question: Question
    
    @State private var isDisclosureGroupOpen = true
    @AppStorage("Picker Type") private var pickerType = 1
    
    var body: some View {
        ZStack {
            questionView
                .offset(y: question.isAnswered ? -UIScreen.main.bounds.height : 0)
            
            resultsView
                .offset(y: question.isAnswered ? 0 : UIScreen.main.bounds.height)
        }
        .padding(.horizontal)
        .safeAreaInset(edge: .top) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    if game.isPlusMode {
                        HStack {
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Name: ")
                                        .bold()
                                    
                                    Text(question.name)
                                        .font(.title)
                                        .bold()
                                        .contentTransition(.numericText())
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(maxWidth: .infinity, alignment: question.isAnswered ? .leading : .center)
                                
                                HStack {
                                    Text("Score to my guess: ")
                                        .bold()
                                    
                                    Text(question.scoreToMyAnswer.formatted(decimalFormat))
                                        .contentTransition(.numericText())
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                                .frame(height: !question.isAnswered ? 0 : nil)
                                .offset(y: !question.isAnswered ? 100 : 0)
                                .clipped()
                            }
                            
                            Group {
                                Gauge(value: question.scoreToMyAnswer) {
                                    Text("")
                                }
                                .tint(question.answer)
                                .frame(width: !question.isAnswered ? 0 : nil)
                                .frame(height: !question.isAnswered ? 0 : nil)
                                .offset(y: !question.isAnswered ? 100 : 0)
                                .clipped()
                            }
                            .gaugeStyle(.accessoryCircular)
                        }
                        .padding(question.isAnswered ? 10 : 0)
                        .glassEffect(question.isAnswered ? .regular.interactive() : .identity, in: RoundedRectangle(cornerRadius: 20))
                    } else {
                        HStack {
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Name: ")
                                        .bold()
                                    
                                    Text(question.name)
                                        .font(.title)
                                        .bold()
                                        .contentTransition(.numericText())
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(maxWidth: .infinity, alignment: question.isAnswered ? .leading : .center)
                                
                                HStack {
                                    Text("Score: ")
                                        .bold()
                                    
                                    Text(question.scoreToCorrectAnswer.formatted(decimalFormat))
                                        .contentTransition(.numericText())
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 10)
                                .frame(height: !question.isAnswered ? 0 : nil)
                                .offset(x: !question.isAnswered ? -100 : 0)
                                .clipped()
                            }
                            
                            Group {
                                Gauge(value: question.scoreToCorrectAnswer) {
                                    Text("")
                                }
                                .tint(question.answer)
                                .frame(width: !question.isAnswered ? 0 : nil)
                                .frame(height: !question.isAnswered ? 0 : nil)
                                .offset(y: !question.isAnswered ? 100 : 0)
                                .clipped()
                            }
                            .gaugeStyle(.accessoryCircular)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        if game.isPlusMode {
                            Text("Score to actual color: ")
                                .padding(.top, 5)
                                .padding(.vertical, 5)
                                
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    HStack {
                                        Text("You: ")
                                            
                                        Text(question.scoreToCorrectAnswer.formatted(decimalFormat))
                                            .bold()
                                            .contentTransition(.numericText())
                                    }
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                        
                                    Gauge(value: question.scoreToCorrectAnswer) {
                                        Text("")
                                    }
                                    .tint(colorScheme == .light ? .black : .white)
                                    .gaugeStyle(.accessoryLinear)
                                }
                                    
                                HStack {
                                    HStack {
                                        Text("Me: ")
                                            
                                        Text(question.myScoreToCorrectAnswer.formatted(decimalFormat))
                                            .bold()
                                            .contentTransition(.numericText())
                                    }
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                        
                                    Gauge(value: question.myScoreToCorrectAnswer) {
                                        Text("")
                                    }
                                    .tint(colorScheme == .light ? .black : .white)
                                    .gaugeStyle(.accessoryLinear)
                                }
                            }
                        }
                    }
                    .frame(height: !question.isAnswered ? 0 : nil)
                    .offset(x: !question.isAnswered ? -100 : 0)
                    .clipped()
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: colorScheme == .light ? .black.opacity(0.25) : .white.opacity(0.25), radius: 1)
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
    
    private var questionView: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(question.guess)
                    .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: colorScheme == .light ? .black : .white, radius: 1)
                    .frame(height: geometry.size.height * 0.25)
                
                Picker("", selection: $pickerType) {
                    Text("Hue")
                        .tag(1)
                    
                    Text("Spectrum")
                        .tag(2)
                }
                .pickerStyle(.segmented)
                
                ZStack {
                    ColorPicker(color: $question.guess)
                        .offset(x: pickerType == 1 ? 0 : -UIScreen.main.bounds.width)
                    
                    SpectrumColorPicker(color: $question.guess)
                        .offset(x: pickerType != 1 ? 0 : UIScreen.main.bounds.width)
                }
                .animation(.default, value: pickerType)
            }
        }
    }
    
    private var resultsView: some View {
        VStack(spacing: 10) {
            if game.isPlusMode {
                makeColorLabel(for: question.myAnswer, title: "My Guess")
                
                makeColorLabel(for: question.guess, title: "Your Guess")
                
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
                
                makeColorLabel(for: question.answer, title: "Actual Color")
            } else {
                makeColorLabel(for: question.answer, title: "Answer")
                
                makeColorLabel(for: question.guess, title: "Your Guess")
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
                    .font(.title3)
                    .bold()
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
