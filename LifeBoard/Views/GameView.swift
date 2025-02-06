//
//  GameView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI

struct GameView: View {
    @State private var isGame1Presented = false
    @State private var isGame2Presented = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button("Matching Cards") {
                    isGame1Presented.toggle()
                }
                .fullScreenCover(isPresented: $isGame1Presented) {
                    MemoryCardsView()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Math Quiz") {
                    isGame2Presented.toggle()
                }
                .fullScreenCover(isPresented: $isGame2Presented) {
                    MathQuizView()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)

                .foregroundColor(.white)
                .cornerRadius(10)
                
                
                Spacer()
            }
            .padding()
            .navigationTitle("Games")
        }
    }
    
}

#Preview {
    GameView()
}

