import SwiftUI

@Observable class Game: Identifiable {
    let id = UUID()
    let mode: Mode
    let questions: [Question]
    let isPlusMode: Bool
    var currentQuestion: Question
    var isComplete = false
    var averageScoreToMyAnswer = 0.0
    var averageScoreToCorrectAnswer = 0.0
    var myAverageScoreToCorrectAnswer = 0.0
    
    init(mode: Mode, isPlusMode: Bool) {
        let colors =
            switch mode {
            case .regular:
                Self.regularColors
            
            case .hard:
                Self.hardColors
                
            case .impossible:
                Self.impossibleColors
            }
        
        let questions: [Question] = colors
            .shuffled()
            .map { .init(answer: $0.answer, name: $0.name, myAnswer: $0.myAnswer, notes: $0.notes) }
        
        self.mode = mode
        self.questions = questions
        self.currentQuestion = questions.first!
        self.isPlusMode = isPlusMode
    }
    
    func nextQuestion() {
        if let nextQuestion = questions.first(where: { !$0.isAnswered }) {
            currentQuestion = nextQuestion
        } else {
            isComplete = true
        }
    }
    
    func calculateAverageScores() {
        averageScoreToMyAnswer = Double(questions.compactMap(\.scoreToMyAnswer).reduce(0, +)) / Double(questions.count)
        averageScoreToCorrectAnswer = Double(questions.compactMap(\.scoreToCorrectAnswer).reduce(0, +)) / Double(questions.count)
        
        if isPlusMode {
            myAverageScoreToCorrectAnswer = Double(questions.compactMap(\.myScoreToCorrectAnswer).reduce(0, +)) / Double(questions.count)
        }
    }
    
    struct Color {
        let answer: SwiftUI.Color
        let name: String
        let myAnswer: SwiftUI.Color
        let notes: String
    }
    
    enum Mode: CaseIterable {
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
    }
}

extension Game {
    static let regularColors: [Color] = [
        .init(answer: .init(red: 255, green: 0, blue: 0),
              name: "Red",
              myAnswer: .init(red: 237, green: 14, blue: 0),
              notes: "This is my favorite color so hopefully this is pretty close."),
        .init(answer: .init(red: 255, green: 68, blue: 51),
              name: "Red-Orange",
              myAnswer: .init(red: 219, green: 115, blue: 35),
              notes: "Ah the color of Doritos. But the cool ranch flavor."),
        .init(answer: .init(red: 255, green: 165, blue: 0),
              name: "Orange",
              myAnswer: .init(red: 242, green: 182, blue: 41),
              notes: "I can usually figure this color out but fun fact the color orange is named after the fruit."),
        .init(answer: .init(red: 255, green: 170, blue: 51),
              name: "Yellow-Orange",
              myAnswer: .init(red: 227, green: 214, blue: 30),
              notes: "Yeah this is literally just yellow."),
        .init(answer: .init(red: 255, green: 255, blue: 0),
              name: "Yellow",
              myAnswer: .init(red: 218, green: 252, blue: 45),
              notes: "Weirdly enough any sort of neon yellow looks green to me."),
        .init(answer: .init(red: 173, green: 255, blue: 47),
              name: "Yellow-Green",
              myAnswer: .init(red: 196, green: 255, blue: 87),
              notes: "I vividly remember using a crayon of this color in kindergarten for some reason."),
        .init(answer: .init(red: 0, green: 255, blue: 0),
              name: "Green",
              myAnswer: .init(red: 41, green: 237, blue: 33),
              notes: "Reds, greens, and browns generally all look the same to me."),
        .init(answer: .init(red: 8, green: 143, blue: 143),
              name: "Blue-Green",
              myAnswer: .init(red: 33, green: 237, blue: 169),
              notes: "I think this is teal? I'll be really sad if it isn't."),
        .init(answer: .init(red: 0, green: 0, blue: 255),
              name: "Blue",
              myAnswer: .init(red: 33, green: 67, blue: 237),
              notes: "Blues, purples, and blacks generally all look the same to me."),
        .init(answer: .init(red: 138, green: 43, blue: 226),
              name: "Blue-Violet",
              myAnswer: .init(red: 143, green: 53, blue: 232),
              notes: "Is this not just purple????"),
        .init(answer: .init(red: 127, green: 0, blue: 255),
              name: "Violet",
              myAnswer: .init(red: 210, green: 79, blue: 224),
              notes: "Honestly I've never understood Violet. How is it different from purple?"),
        .init(answer: .init(red: 199, green: 21, blue: 133),
              name: "Red-Violet",
              myAnswer: .init(red: 222, green: 67, blue: 136),
              notes: "Yeah combined colors are not good for me.")
    ]
    
    static let hardColors: [Color] = [
        .init(answer: .init(red: 127, green: 255, blue: 0),
              name: "Chartreuse",
              myAnswer: .init(red: 0, green: 128, blue: 128),
              notes: "No idea what this is but I like saying the name of it."),
        .init(answer: .init(red: 255, green: 0, blue: 255),
              name: "Fuchsia",
              myAnswer: .init(red: 232, green: 122, blue: 127),
              notes: "My first thought is the color Fuchsia City from Pokémon... yeah imma go with that."),
        .init(answer: .init(red: 255, green: 0, blue: 187),
              name: "Purple Pizzazz",
              myAnswer: .init(red: 218, green: 0, blue: 154),
              notes: "I think I can safely assume this has gotta be purple-ish. But Pizzazz? Drop the last 2 Zs and it's Pizza so I'm going with red-purple."),
        .init(answer: .init(red: 255, green: 185, blue: 123),
              name: "Macaroni and Cheese",
              myAnswer: .init(red: 255, green: 244, blue: 21),
              notes: "The question here is it the unnatural color of Kraft or is it real cheese?"),
        .init(answer: .init(red: 255, green: 128, blue: 165),
              name: "Tickle Me Pink",
              myAnswer: .init(red: 255, green: 154, blue: 225),
              notes: "Ooh I get a strategy for this one, I'm gonna tickle myself and see what color I turn."),
        .init(answer: .init(red: 135, green: 66, blue: 31),
              name: "Fuzzy Wuzzy",
              myAnswer: .init(red: 71, green: 43, blue: 0),
              notes: "This has to be brown. Can't explain it it's just a gut feeling."),
        .init(answer: .init(red: 2, green: 164, blue: 211),
              name: "Cerulean",
              myAnswer: .init(red: 79, green: 219, blue: 255),
              notes: "Oh I know this one, it's somewhere in the blue range. Look at me knowing things😎."),
        .init(answer: .init(red: 156, green: 148, blue: 187),
              name: "Snugglepuss",
              myAnswer: .init(red: 110, green: 29, blue: 255),
              notes: "My brain has a thought but it's not family friendly and I don't want to get in trouble. We'll go with purple."),
        .init(answer: .init(red: 227, green: 37, blue: 107),
              name: "Razzmatazz",
              myAnswer: .init(red: 194, green: 62, blue: 39),
              notes: "In my head I say this like I'm saying the word Razzberry but in the middle of it I get electrocuted. Razz-*matazz*. Blue-ish red it is."),
        .init(answer: .init(red: 0, green: 20, blue: 168),
              name: "Zaffre",
              myAnswer: .init(red: 45, green: 89, blue: 128),
              notes: "???🤨. I don't know man... blue or green I'll flip a coin."),
        .init(answer: .init(red: 128, green: 24, blue: 24),
              name: "Falu",
              myAnswer: .init(red: 199, green: 222, blue: 0),
              notes: "This is a real color? I couldn't get this even if I wasn't colorblind. My uneducated guess is this is a type of mustard like Dijon. Brown-ish yellow."),
        .init(answer: .init(red: 96, green: 130, blue: 182),
              name: "Glaucous",
              myAnswer: .init(red: 24, green: 135, blue: 0),
              notes: "Not even sure how to pronounce this much less what it looks like. It's spelled similar to Glaucoma but I don't think that helps me.")
    ]
    
    static let impossibleColors: [Color] = [
        .init(answer: .init(red: 129, green: 152, blue: 174),
              name: "Dryer's Woad",
              myAnswer: .init(red: 219, green: 213, blue: 186),
              notes: "Dryer as in for clothes? My dryer has a hard time with comforters so I'll go with the color of mine."),
        .init(answer: .init(red: 131, green: 154, blue: 138),
              name: "Parisian Patina",
              myAnswer: .init(red: 216, green: 235, blue: 7),
              notes: "How am I supposed to know this? Can I get a hint?"),
        .init(answer: .init(red: 246, green: 202, blue: 69),
              name: "Forsythia",
              myAnswer: .init(red: 14, green: 226, blue: 237),
              notes: "I'm reading this like 'For Sythia'. Like a battle cry and maybe Sythia is the name of a place or person. Teal"),
        .init(answer: .init(red: 167, green: 134, blue: 89),
              name: "Chamois",
              myAnswer: .init(red: 237, green: 223, blue: 202),
              notes: "Sounds french. Not to be stereotypical but I'm feeling the color of a baguette."),
        .init(answer: .init(red: 246, green: 201, blue: 77),
              name: "Cheerful",
              myAnswer: .init(red: 15, green: 250, blue: 84),
              notes: "An emotion? Well, mad is red and blue is sad. Maybe happy is green?"),
        .init(answer: .init(red: 129, green: 182, blue: 197),
              name: "Nautilus",
              myAnswer: .init(red: 91, green: 104, blue: 227),
              notes: "Pretty sure a Nautilus is an ancient sea creature? Has to be blue."),
        .init(answer: .init(red: 112, green: 105, blue: 149),
              name: "Forget-Me-Not",
              myAnswer: .init(red: 224, green: 120, blue: 227),
              notes: "Is the color asking me to not forget it? Sorry buddy I've already ejected you from my brain and I dub you pink for the irony."),
        .init(answer: .init(red: 186, green: 126, blue: 148),
              name: "Cyclamen",
              myAnswer: .init(red: 149, green: 114, blue: 150),
              notes: "Is this a man that has the powers of a bicycle? My bike is purple (Don't make fun of me it's my mom's old bike, and she's dead)."),
        .init(answer: .init(red: 208, green: 125, blue: 103),
              name: "Rejuvenate",
              myAnswer: .init(red: 175, green: 202, blue: 237),
              notes: "I once saw a bottle of shampoo named this and it was a light blue color so I'll send it."),
        .init(answer: .init(red: 114, green: 139, blue: 166),
              name: "Scanda",
              myAnswer: .init(red: 166, green: 166, blue: 56),
              notes: "Scanda... Scand... Sand!"),
        .init(answer: .init(red: 125, green: 119, blue: 140),
              name: "Mythical",
              myAnswer: .init(red: 227, green: 22, blue: 11),
              notes: "This is literally just an adjective. I'm losing my will to live."),
        .init(answer: .init(red: 106, green: 100, blue: 92),
              name: "Porpoise",
              myAnswer: .init(red: 236, green: 108, blue: 133),
              notes: "A pontificating porpoise ponders polytheism palpably. Boom alliteration.")
    ]
}

let decimalFormat = FloatingPointFormatStyle<Double>.Percent().precision(.significantDigits(3)).rounded(rule: .up)

extension Color {
    init(red: Int, green: Int, blue: Int) {
        self.init(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }
}
