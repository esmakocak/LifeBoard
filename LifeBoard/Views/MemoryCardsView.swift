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
        let emojis = ["☕️", "🕯️", "🪩", "🎀", "🌷","🧸"]
        let shuffledEmojis = (emojis + emojis).shuffled()
        cards = shuffledEmojis.map { Card(emoji: $0) }
        isGameOver = false
    }
}

struct MemoryCardsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = MemoryGameViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()  // 📌 Sayfayı kapat
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .padding()
                    }
                    
                    Spacer()
                }
                
                Text("Matching Cards")
                    .font(.title)
                    .foregroundStyle(.black)
                    .bold()
                    .padding(.top, 20)
                
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
                        Text("🎉 Congrats! You found all pairs! 🎉")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Button("Play Again") {
                            viewModel.resetGame()
                        }
                        .padding()
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .frame(width: 150)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(maxHeight: .infinity)
        
    }
}

struct CardView: View {
    var card: Card
    
    var body: some View {
        ZStack {
            if card.isFlipped {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("lightPink"))
                    .frame(width: 110, height: 110)
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 3)
                Text(card.emoji)
                    .font(.system(size: 55))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("darkPink"))
                    .frame(width: 110, height: 110)
                    .shadow(radius: 2)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: card.isFlipped)
    }
}


#Preview {
    MemoryCardsView()
}
