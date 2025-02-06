//
//  GameView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                NavigationLink(destination: MemoryCardsView()) {
                    gameButton(title: "Memory Matching")
                }
                
                NavigationLink(destination: MathQuizView()) {
                    gameButton(title: "Oyun 2")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Games")
        }         
    }
    
    @ViewBuilder
    private func gameButton(title: String) -> some View {
        Text(title)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color.blue.opacity(0.2))
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}

#Preview {
    GameView()
}

