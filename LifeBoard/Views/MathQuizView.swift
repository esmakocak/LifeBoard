//
//  MathQuizView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 6.02.2025.
//

import SwiftUI

import SwiftUI

struct MathQuizView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MathGameViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                }
                
                // Başlık
                Text("Math Quiz")
                    .font(.title)
                    .foregroundStyle(.black)
                    .bold()
                    .padding(.top, 20)
                
                // Soru ve cevap seçenekleri
                Text("\(viewModel.firstNumber) + \(viewModel.secondNumber)")
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    .bold()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.choiceArray, id: \.self) { number in
                        Button {
                            viewModel.answerIsCorrect(answer: number)
                        } label: {
                            AnswerButton(
                                number: number,
                                selectedAnswer: viewModel.selectedAnswer,
                                correctAnswer: viewModel.correctAnswer,
                                isCorrectAnswerSelected: viewModel.isCorrectAnswerSelected
                            )
                        }
                    }
                }
                .padding()
                
                // Skor göstergesi
                Text("Score: \(viewModel.score)")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .bold()
                
                Spacer()
            }
            
            // Oyun bittiğinde
            if viewModel.gameOver {
                VStack {
                    Spacer()
                    VStack {
                        Text("🎉 Congrats! Your Score: \(viewModel.score)")
                            .font(.title2)
                            .bold()
                            .padding()
                            .foregroundStyle(.black)

                        Button(action: viewModel.resetGame) {
                            Text("Play Again")
                                .font(.title2)
                                .bold()
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct AnswerButton: View {
    var number: Int
    var selectedAnswer: Int?
    var correctAnswer: Int
    var isCorrectAnswerSelected: Bool?

    var body: some View {
        Text("\(number)")
            .frame(width: 110, height: 110)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .background(buttonColor)
            .clipShape(Circle())
            .padding()
    }

    private var buttonColor: Color {
        if let selected = selectedAnswer {
            if selected == number {
                return (isCorrectAnswerSelected == true) ? .green : .red
            } else if number == correctAnswer && isCorrectAnswerSelected == false {
                return .green
            }
        }
        return .blue
    }
}

#Preview {
    MathQuizView()
}
