import SwiftUI

enum Difficulty: CaseIterable {
    case regular
    case hard
    case impossible
    
    var title: String {
        switch self {
        case .regular: "Regular"
        case .hard: "Hard"
        case .impossible: "Impossible"
        }
    }
    
    var description: String {
        switch self {
        case .regular: "Simple colors found on the color wheel, nothing too tricky here👍."
        case .hard: "Ya know Crayola crayons🖍️? Yeah those types of names."
        case .impossible: "Sherwin Williams paint👨‍🎨 colors. Good luck buckaroo!"
        }
    }
    
    var gaugeColor: SwiftUI.Color {
        switch self {
        case .regular: .green
        case .hard: .yellow
        case .impossible: .red
        }
    }
    
    var gaugeValue: Double {
        switch self {
        case .regular: 1 / 3
        case .hard: 2 / 3
        case .impossible: 1
        }
    }
    
    var questions: [Question] {
        let colors =
            switch self {
            case .regular:
                Self.regularColors
            
            case .hard:
                Self.hardColors
                
            case .impossible:
                Self.impossibleColors
            }
        
        return colors
            .shuffled()
            .map { .init(answer: $0.answer, name: $0.name, myAnswer: $0.myAnswer, notes: $0.notes) }
    }
}
