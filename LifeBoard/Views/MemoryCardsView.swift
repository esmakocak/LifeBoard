//
//  MemoryCardsView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 6.02.2025.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let emoji: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

class MemoryGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var firstSelectedIndex: Int? = nil
    @Published var isGameOver = false
    
    init() {
        resetGame()
    }

    func flipCard(_ index: Int) {
        guard !cards[index].isMatched else { return }
        guard !cards[index].isFlipped else { return }
        
        if let firstIndex = firstSelectedIndex {
            // İkinci kart seçildi, karşılaştırma yap
            if cards[firstIndex].emoji == cards[index].emoji {
                // Eşleşme oldu
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
                HapticManager.instance.notification(type: .success) // Doğru eşleşme titreşimi
                
                if cards.allSatisfy({ $0.isMatched }) {
                    isGameOver = true // Tüm kartlar eşleştiğinde oyunu bitir
                }
            } else {
                // Yanlış eşleşme, hata titreşimi
                HapticManager.instance.notification(type: .error)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.cards[firstIndex].isFlipped = false
                    self.cards[index].isFlipped = false
                }
            }
            firstSelectedIndex = nil
        } else {
            // İlk kart seçildi
            firstSelectedIndex = index
        }
        cards[index].isFlipped.toggle()
    }
    
    func resetGame() {
        let emojis = ["🩵", "🫐", "🦋", "💙", "🧿","❄️"]
        let shuffledEmojis = (emojis + emojis).shuffled()
        cards = shuffledEmojis.map { Card(emoji: $0) }
        isGameOver = false
    }
}

struct MemoryCardsView: View {
    @StateObject private var viewModel = MemoryGameViewModel()

    var body: some View {
        ZStack {
            VStack {
                Text("Matching Cards")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)

                // 📌 Grid düzenini sabit tutuyoruz
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                    ForEach(viewModel.cards.indices, id: \.self) { index in
                        CardView(card: viewModel.cards[index])
                            .onTapGesture {
                                viewModel.flipCard(index)
                            }
                    }
                }
                .padding()
                
                Spacer()
            }
            
            if viewModel.isGameOver {
                VStack {
                    Spacer()
                    VStack {
                        Text("🎉 Tebrikler! Oyunu Bitirdin! 🎉")
                            .font(.title2)
                            .foregroundColor(.green)
                            .padding()

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
            }
        }
        .frame(maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct CardView: View {
    var card: Card

    var body: some View {
        ZStack {
            if card.isFlipped {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 110, height: 110)
                    .shadow(radius: 5)
                Text(card.emoji)
                    .font(.system(size: 55))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 110, height: 110)
                    .shadow(radius: 5)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: card.isFlipped)
    }
}

class HapticManager {
    static let instance = HapticManager() // Singleton
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

#Preview {
    MemoryCardsView()
}
