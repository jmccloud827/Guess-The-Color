import SwiftUI

@Observable class Question {
    let answer: Color
    let name: String
    let myAnswer: Color
    let notes: String
    var guess: Color = .init(hue: 0, saturation: 0.5, brightness: 0.5)
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
        scoreToMyAnswer = Self.getScoreFor(guess: guess, answer: myAnswer)
        scoreToCorrectAnswer = Self.getScoreFor(guess: guess, answer: answer)
        myScoreToCorrectAnswer = Self.getScoreFor(guess: myAnswer, answer: answer)
    }
    
    private static func getScoreFor(guess: Color, answer: Color) -> Double {
        let guessHSB = guess.getHSB()
        let answerHSB = answer.getHSB()
        
        let saturationPercent = 1 - abs(answerHSB.saturation - guessHSB.saturation)
        let brightnessPercent = 1 - abs(answerHSB.brightness - guessHSB.brightness)
        
        let worstAnswerHue =
            if answerHSB.hue < 0.5 {
                answerHSB.hue + 0.5
            } else {
                answerHSB.hue - 0.5
            }
        
        let worstDifference = abs(guessHSB.hue - worstAnswerHue)
        let bestDifference = abs(guessHSB.hue - answerHSB.hue)
        
        let huePercent =
            if worstDifference < bestDifference {
                worstDifference * 2
            } else {
                1 - bestDifference * 2
            }
        
        return huePercent * 0.7 + saturationPercent * 0.15 + brightnessPercent * 0.15
    }
}
