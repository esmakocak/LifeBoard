//
//  NoteView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI
import AVFoundation

struct NoteView: View {
    @State private var isAddingNote = false
    @State private var notes: [String] = []  // Notları tutacak dizi
    private let speechSynthesizer = AVSpeechSynthesizer() // Sesli okuma motoru

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(notes, id: \.self) { note in
                        HStack {
                            Text(note)  // Kaydedilen notları göster

                            Spacer()

                            Button(action: {
                                speakText(note)
                            }) {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                            }
                            .accessibilityLabel("\(note) notunu sesli oku") // VoiceOver etiketi
                        }
                    }
                }

                Button(action: {
                    isAddingNote = true
                }) {
                    Text("Yeni Not Ekle")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isAddingNote) {
                    AddNoteView(notes: $notes)  // Binding ile notları ilet
                }

                Spacer()
            }
            .navigationTitle("Notes")
        }
    }

    // 🔊 **Sistem Dilini Algılayarak Notları Seslendirme**
    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        
        // Kullanıcının telefonunun dili (örn: "tr", "en", "fr", "hi" vb.)
        let systemLanguageCode = Locale.current.language.languageCode?.identifier ?? "en"
        
        // TTS sisteminde uygun ses olup olmadığını kontrol et
        if let voice = AVSpeechSynthesisVoice(language: systemLanguageCode) {
            utterance.voice = voice
        } else {
            // Eğer sistemde o dilin sesi yoksa, İngilizce kullan
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        speechSynthesizer.speak(utterance)
    }
}

#Preview {
    NoteView()
}
