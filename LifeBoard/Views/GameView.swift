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
                
                // MARK: MEMORY CARDS BUTTON
                Button {
                    isGame1Presented.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("lightPink"))
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .overlay(
                            ZStack {
                                
                                Image(systemName: "square.stack.3d.down.forward")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color("darkPink").opacity(0.5))
                                    .frame(width: 55, height: 55)
                                    .offset(x: -135, y: 30)
                                
                                Image(systemName: "sparkles")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color("darkPink").opacity(0.5))
                                    .frame(width: 45, height: 45)
                                    .offset(x: 135, y: -30)
                                
                                Text("Memory Cards")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                            }
                        )
                }
                .fullScreenCover(isPresented: $isGame1Presented) {
                    MemoryCardsView()
                }
                
                // MARK: MATH QUIZ BUTTON
                Button {
                    isGame2Presented.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("lightPurple"))
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .overlay(
                            ZStack {
                                Text("1")
                                    .font(.system(size: 35, weight: .bold))
                                    .foregroundColor(Color("darkPurple").opacity(0.5))
                                    .offset(x: -140, y: 40)
                                    .rotationEffect(.degrees(10))
                                
                                Text("2")
                                    .font(.system(size: 35, weight: .bold))
                                    .foregroundColor(Color("darkPurple").opacity(0.5))
                                    .offset(x: -90, y: -70)
                                    .rotationEffect(.degrees(-20))
                                
                                Text("3")
                                    .font(.system(size: 35, weight: .bold))
                                    .foregroundColor(Color("darkPurple").opacity(0.5))
                                    .offset(x: -70, y: 70)
                                    .rotationEffect(.degrees(20))
                                
                                Text("=")
                                    .font(.system(size: 45, weight: .bold))
                                    .foregroundColor(Color("darkPurple").opacity(0.5))
                                    .offset(x: 120, y: -60)
                                    .rotationEffect(.degrees(10))
                                
                                Image(systemName: "plus")
                                    .resizable()
                                    .bold()
                                
                                    .scaledToFit()
                                    .foregroundColor(Color("darkPurple").opacity(0.5))
                                    .frame(width: 40, height: 40)
                                    .offset(x: 120, y: 30)
                                
                                Text("Math Quiz")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.black)
                            }
                        )
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
