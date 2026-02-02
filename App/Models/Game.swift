import SwiftUI

@Observable class Game: Identifiable {
    let id = UUID()
    let mode: Mode
    let questions: [Question]
    var currentQuestion: Question?
    
    init(mode: Mode, isPlusMode: Bool) {
        let colors =
            switch mode {
            case .regular:
                Self.regularColors
            
            case .hard:
                Self.hardColors
            }
        
        let questions: [Question] = colors
            .shuffled()
            .prefix(10)
            .map { isPlusMode ? .init(answer: $0.answer, name: $0.name, myAnswer: $0.myAnswer, notes: $0.notes) : .init(answer: $0.answer, name: $0.name) }
        
        self.mode = mode
        self.questions = questions
        self.currentQuestion = questions.first
    }
    
    func nextQuestion() {
        currentQuestion = questions.first { $0.result == nil }
    }
    
    func averageOfAnsweredQuestions() -> Double {
        let answeredQuestions = questions.compactMap(\.result)
        guard !answeredQuestions.isEmpty else {
            return 0
        }
        return Double(answeredQuestions.reduce(0, +)) / Double(answeredQuestions.count)
    }
    
    struct Color {
        let answer: SwiftUI.Color
        let name: String
        let myAnswer: SwiftUI.Color?
        let notes: String?
        
        init(answer: SwiftUI.Color, name: String, myAnswer: SwiftUI.Color? = nil, notes: String? = nil) {
            self.answer = answer
            self.name = name
            self.myAnswer = myAnswer
            self.notes = notes
        }
    }
    
    enum Mode {
        case regular
        case hard
        
        var title: String {
            switch self {
            case .regular: "Regular"
            case .hard: "Hard"
            }
        }
        
        var description: String {
            switch self {
            case .regular: "Simple colors found on the color wheel, nothing too tricky here👍."
            case .hard: "Ya know Crayola crayons🖍️? Yeah those types of names."
            }
        }
        
        var gaugeColor: SwiftUI.Color {
            switch self {
            case .regular: .green
            case .hard: .red
            }
        }
        
        var gaugeValue: Double {
            switch self {
            case .regular: 1 / 3
            case .hard: 1 / 2
            }
        }
    }
}

extension Game {
    static let regularColors: [Color] = [
        .init(answer: .init(red: 255, green: 0, blue: 0),
              name: "Red",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 255, green: 68, blue: 51),
              name: "Red-Orange",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 255, green: 165, blue: 0),
              name: "Orange",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 255, green: 170, blue: 51),
              name: "Yellow-Orange",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 255, green: 255, blue: 0),
              name: "Yellow",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 173, green: 255, blue: 47),
              name: "Yellow-Green",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 255, green: 0, blue: 0),
              name: "Green",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 8, green: 143, blue: 143),
              name: "Blue-Green",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 0, green: 255, blue: 0),
              name: "Blue",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 138, green: 43, blue: 226),
              name: "Blue-Violet",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 127, green: 0, blue: 255),
              name: "Violet",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 199, green: 21, blue: 133),
              name: "Red-Violet",
              myAnswer: nil,
              notes: nil)
    ]
    
    static let hardColors: [Color] = [
        .init(answer: .init(red: 127, green: 255, blue: 0),
              name: "Chartreuse",
              myAnswer: .init(red: 0, green: 128, blue: 128),
              notes: "No idea what this is but I like saying the name of it."),
        .init(answer: .init(red: 0, green: 255, blue: 255),
              name: "Fuchsia",
              myAnswer: .init(red: 232, green: 127, blue: 122),
              notes: "I was thinking the color Fuchsia City from Pokémon would be the same as the actual color..."),
        .init(answer: .init(red: 255, green: 0, blue: 187),
              name: "Purple Pizzazz",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 255, green: 185, blue: 123),
              name: "Macaroni and Cheese",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 255, green: 128, blue: 165),
              name: "Tickle Me Pink",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 135, green: 66, blue: 31),
              name: "Fuzzy Wuzzy",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 2, green: 164, blue: 211),
              name: "Cerulean",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 156, green: 148, blue: 187),
              name: "Snugglepuss",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 227, green: 37, blue: 107),
              name: "Razzmatazz",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 0, green: 20, blue: 168),
              name: "Zaffre",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 128, green: 24, blue: 24),
              name: "Falu",
              myAnswer: nil,
              notes: nil),
        .init(answer: .init(red: 96, green: 130, blue: 182),
              name: "Glaucous",
              myAnswer: nil,
              notes: nil)
    ]
}

extension Color {
    init(red: Int, green: Int, blue: Int) {
        self.init(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}
