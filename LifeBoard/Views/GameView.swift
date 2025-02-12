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
                Button {
                    isGame1Presented.toggle()
                } label: {
                    Text("Matching Cards")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isGame1Presented) {
                    MemoryCardsView()
                }

                Button {
                    isGame2Presented.toggle()
                } label: {
                    Text("Math Quiz")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isGame2Presented) {
                    MathQuizView()
                }
                
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

