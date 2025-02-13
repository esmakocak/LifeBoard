//
//  WelcomeView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 13.02.2025.
//
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            BackgroundIconsView()
            
            VStack(spacing: 20) {
                Text("Life Board")
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                
                Text("Take notes, exercise your brain daily. Memorize things.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: {
                    // Kullanıcı ilerlediğinde bir flag değiştirilecek
                    UserDefaults.standard.set(true, forKey: "hasSeenWelcomeScreen")
                }) {
                    Text("Get Started")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .padding(.horizontal, 60)
                }
            }
            .offset(y: -10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}


struct BackgroundIconsView: View {
    @State private var isAnimating = false
    @State private var angle: Double = 0

    let icons: [(name: String, backgroundColor: Color, iconColor: Color, position: CGPoint, size: CGFloat)] = [
        ("pill.fill", Color("lightPink"), Color("darkPink"), CGPoint(x: 80, y: 80), 70),
        ("bell.fill", Color("lightBlue"), Color("darkBlue"), CGPoint(x: 310, y: 140), 100),
        ("gamecontroller.fill", Color("lightBlue"), Color("darkBlue"), CGPoint(x: 70, y: 580), 85),
        ("heart.fill", Color("lightPink"), Color("darkPink"), CGPoint(x: 320, y: 570), 65),
        ("brain", Color("lightPurple"), Color("darkPurple"), CGPoint(x: 165, y: 190), 90),
        ("note.text", Color("lightPurple"), Color("darkPurple"), CGPoint(x: 200, y: 670), 95)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(icons, id: \.name) { icon in
                Circle()
                    .fill(icon.backgroundColor)
                    .frame(width: icon.size, height: icon.size)
                    .overlay(
                        Image(systemName: icon.name)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(icon.iconColor)
                            .frame(width: icon.size * 0.5, height: icon.size * 0.5) // İkonun boyutu
                    )
                    .scaleEffect(isAnimating ? 1.1 : 1.0) // Büyütme & Küçültme
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                    }

                    .position(icon.position)
            }
        }
    }
}


#Preview {
    WelcomeView()
}



