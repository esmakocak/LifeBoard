//
//  MathQuizView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 6.02.2025.
//

import SwiftUI

class MathQuizViewModel: ObservableObject {
    @Published var question: String = ""
    @Published var choices: [Int] = []
    @Published var correctAnswer: Int = 0
    @Published var score: Int = 0
    @Published var currentQuestionIndex: Int = 0
    @Published var isGameOver: Bool = false
    @Published var selectedAnswer: Int? = nil
    
    let totalQuestions = 5

    init() {
        generateQuestion()
    }

    func generateQuestion() {
        let num1 = Int.random(in: 1...20)
        let num2 = Int.random(in: 1...20)
        let operation = ["+", "-", "×"].randomElement()!
        
        switch operation {
        case "+":
            correctAnswer = num1 + num2
        case "-":
            correctAnswer = num1 - num2
        case "×":
            correctAnswer = num1 * num2
        default:
            correctAnswer = num1 + num2
        }
        
        question = "\(num1) \(operation) \(num2) = ?"
        
        var options = [correctAnswer]
        while options.count < 4 {
            let randomOption = Int.random(in: (correctAnswer - 5)...(correctAnswer + 5))
            if randomOption != correctAnswer && randomOption >= 0 {
                options.append(randomOption)
            }
        }
        
        choices = options.shuffled()
    }

    func checkAnswer(_ answer: Int) {
        guard !isGameOver else { return }
        
        selectedAnswer = answer
        if answer == correctAnswer {
            score += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nextQuestion()
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < totalQuestions - 1 {
            currentQuestionIndex += 1
            generateQuestion()
        } else {
            isGameOver = true
        }
        selectedAnswer = nil
    }

    func resetGame() {
        score = 0
        currentQuestionIndex = 0
        isGameOver = false
        generateQuestion()
    }

    func buttonColor(for choice: Int) -> Color {
        if selectedAnswer == choice {
            return choice == correctAnswer ? .green : .red
        }
        return .blue
    }
}

struct MathQuizView: View {
    @StateObject private var viewModel = MathQuizViewModel()

    var body: some View {
        VStack {
            Text("Math Quiz")
                .font(.title)
                .bold()
                .padding(.top, 20)

            Text(viewModel.question)
                .font(.title)
                .bold()
                .padding()

            VStack(spacing: 15) {
                ForEach(viewModel.choices, id: \.self) { choice in
                    Button(action: {
                        viewModel.checkAnswer(choice)
                    }) {
                        Text("\(choice)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.buttonColor(for: choice))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .animation(.easeInOut, value: viewModel.selectedAnswer)
                    }
                    .disabled(viewModel.isGameOver) // Eğer oyun bittiyse butonları devre dışı bırak
                }
            }
            .padding()

            if viewModel.isGameOver {
                VStack {
                    Text("Skor: \(viewModel.score)/\(viewModel.totalQuestions)")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.green)

                    Button("Tekrar Oyna") {
                        viewModel.resetGame()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MathQuizView()
}
