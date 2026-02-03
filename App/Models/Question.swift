import SwiftUI

@Observable class Question {
    let answer: Color
    let name: String
    let myAnswer: Color
    let notes: String
    var guess: Color = .init(hue: 0, saturation: 1, brightness: 0.9999999)
    var scoreToMyAnswer = 0.0
    var scoreToCorrectAnswer = 0.0
    var myScoreToCorrectAnswer = 0.0
    var isAnswered = false
    
    init(answer: Color, name: String, myAnswer: Color, notes: String) {
        self.answer = answer
        self.name = name
        self.myAnswer = myAnswer
        self.notes = notes
    }
    
    func calculateScores() {
        scoreToMyAnswer = Self.getScore(guess: guess, answer: myAnswer)
        scoreToCorrectAnswer = Self.getScore(guess: guess, answer: answer)
        myScoreToCorrectAnswer = Self.getScore(guess: myAnswer, answer: answer)
    }
    
    private static func getScore(guess: Color, answer: Color) -> Double {
        let guessRGB = guess.getRGB()
        let answerRGB = answer.getRGB()
        
        let redPercent = 1 - abs(answerRGB.red - guessRGB.red)
        let greenPercent = 1 - abs(answerRGB.green - guessRGB.green)
        let bluePercent = 1 - abs(answerRGB.blue - guessRGB.blue)
        
        let average = (redPercent + greenPercent + bluePercent) / 3
        
        return average
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
