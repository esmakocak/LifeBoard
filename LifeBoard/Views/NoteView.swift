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
    @State private var notes: [(text: String, color: Color)] = [] // Notlar artık renk içeriyor
    private let speechSynthesizer = AVSpeechSynthesizer()

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(notes.indices, id: \.self) { index in
                            noteCard(note: notes[index].text, color: notes[index].color)
                        }
                    }
                    .padding()
                }

                Button(action: {
                    isAddingNote = true
                }) {
                    Text("+")
                        .font(.title)
                        .bold()
                        .frame(width: 30)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .sheet(isPresented: $isAddingNote) {
                    AddNoteView(notes: $notes) // Yeni not ekleme ekranı
                }

                Spacer()
            }
            .navigationTitle("Notes")
        }
    }

    // 🔹 Notları Kart Formatında Gösteren View
    @ViewBuilder
    private func noteCard(note: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note)
                .font(.body)
                .padding()
                .foregroundColor(.black)

            HStack {
                Text(Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 10)

                Spacer()

                Button(action: {
                    speakText(note)
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                }
                .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    // 🔊 **Sistem Dilini Algılayarak Notları Seslendirme**
    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        let systemLanguageCode = Locale.current.language.languageCode?.identifier ?? "en"

        if let voice = AVSpeechSynthesisVoice(language: systemLanguageCode) {
            utterance.voice = voice
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }

        speechSynthesizer.speak(utterance)
    }
}

#Preview {
    NoteView()
}
