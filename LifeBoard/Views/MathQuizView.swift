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
                    .padding(.top, 20)

                
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
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.bottom)

                        Button(action: viewModel.resetGame) {
                            Text("Play Again")
                                .padding()
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .frame(width: 150)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            
                        }
                    }
                    .padding()
                    .padding(.bottom, 40)
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
            .font(.system(size: 40, weight: .bold, design: .rounded))
            .foregroundColor(.black)
            .background(buttonColor)
            .clipShape(Circle())
            .padding()
    }

    private var buttonColor: Color {
        if let selected = selectedAnswer {
            if selected == number {
                return (isCorrectAnswerSelected == true) ? Color("customGreen") : Color("customRed")
            } else if number == correctAnswer && isCorrectAnswerSelected == false {
                return Color("customGreen")
            }
        }
        return Color("lightPurple")
    }
}

#Preview {
    MathQuizView()
}
