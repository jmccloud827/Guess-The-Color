import SwiftUI

@Observable class Game: Identifiable {
    let id = UUID()
    let difficulty: Difficulty
    let questions: [Question]
    let isPlusMode: Bool
    var currentQuestion: Question
    var isComplete = false
    var averageScoreToMyAnswer = 0.0
    var averageScoreToCorrectAnswer = 0.0
    var myAverageScoreToCorrectAnswer = 0.0
    
    init(difficulty: Difficulty, isPlusMode: Bool) {
        self.difficulty = difficulty
        self.questions = difficulty.questions
        self.currentQuestion = difficulty.questions.first!
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
}
