import SwiftUI

@Observable class Question {
    let answer: Color
    let name: String
    let myAnswer: Color?
    let notes: String?
    var guess: Color = .black
    var result: Double?
    
    init(model: Game.Color) {
        self.answer = model.answer
        self.name = model.name
        self.myAnswer = model.myAnswer
        self.notes = model.notes
    }
    
    func commitAnswer() {
        result = 0
    }
    
    func calculateResult() {
        let guessRGB = guess.getRGB()
        let answerRGB =
            if let myAnswer {
                myAnswer.getRGB()
            } else {
                answer.getRGB()
            }
        
        let redPercent = 1 - abs(answerRGB.red - guessRGB.red)
        let greenPercent = 1 - abs(answerRGB.green - guessRGB.green)
        let bluePercent = 1 - abs(answerRGB.blue - guessRGB.blue)
        
        let average = (redPercent + greenPercent + bluePercent) / 3
        
        result = average
    }
}

extension Color {
    func getRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue)
    }
}
