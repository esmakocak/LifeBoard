//
//  MathGameViewModel.swift
//  LifeBoard
//
//  Created by Esma Koçak on 10.02.2025.
//

import SwiftUI

class MathGameViewModel: ObservableObject {
    @Published var correctAnswer = 0
    @Published var choiceArray: [Int] = [0, 1, 2, 3]
    @Published var firstNumber = 0
    @Published var secondNumber = 0
    @Published var difficulty = 100
    @Published var score = 0
    @Published var questionCount = 0
    @Published var gameOver = false
    
    @Published var selectedAnswer: Int? = nil
    @Published var isCorrectAnswerSelected: Bool? = nil
    @Published var isAnswerSelected: Bool = false
    
    init() {
        generateAnswers()
    }
    
    func answerIsCorrect(answer: Int) {
        guard !isAnswerSelected else { return }
        
        selectedAnswer = answer
        isCorrectAnswerSelected = (answer == correctAnswer)
        isAnswerSelected = true
        
        if isCorrectAnswerSelected == true {
            score += 1
            HapticManager.instance.notification(type: .success)
        } else {
            HapticManager.instance.notification(type: .error)
        }
        
        questionCount += 1
        
        if questionCount >= 5 {
            gameOver = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.generateAnswers()
                self.selectedAnswer = nil
                self.isCorrectAnswerSelected = nil
                self.isAnswerSelected = false // Activate buttons when new question appears
            }
        }
    }
    
    func generateAnswers() {
        firstNumber = Int.random(in: 0...(difficulty / 2))
        secondNumber = Int.random(in: 0...(difficulty / 2))
        correctAnswer = firstNumber + secondNumber
        
        var answerList = Set<Int>()
        
        while answerList.count < 3 {
            let randomWrongAnswer = Int.random(in: 0...difficulty)
            if randomWrongAnswer != correctAnswer {
                answerList.insert(randomWrongAnswer)
            }
        }
        
        answerList.insert(correctAnswer)
        choiceArray = Array(answerList).shuffled()
    }
    
    func resetGame() {
        DispatchQueue.main.async {
            self.score = 0
            self.questionCount = 0
            self.gameOver = false
            self.selectedAnswer = nil
            self.isCorrectAnswerSelected = nil
            self.isAnswerSelected = false
            self.generateAnswers()
        }
    }
}
