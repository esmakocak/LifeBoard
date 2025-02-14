//
//  NoteView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI
import AVFoundation
import CoreData

struct NoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: NoteViewModel

    @State private var isAddingNote = false
    private let speechSynthesizer = AVSpeechSynthesizer()

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: NoteViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        HStack(alignment: .top, spacing: 10) {
                            VStack {
                                // İlk yarısını göster
                                ForEach(viewModel.notes.prefix(viewModel.notes.count / 2)) { note in
                                    noteCard(note: note)
                                }
                            }
                            VStack {
                                // İkinci yarısını göster
                                ForEach(viewModel.notes.suffix(viewModel.notes.count / 2)) { note in
                                    noteCard(note: note)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Notes")
                .onAppear {
                    NotificationManager.shared.requestNotificationPermission()
                }
            }
            .overlay(
                // 📌 **Floating Action Button (FAB)**
                Button(action: {
                    isAddingNote = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .bold))
                        .frame(width: 60, height: 60)
                        .background(Color.black) // FAB arka plan rengi
                        .foregroundColor(.white) // İkon rengi
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
                .sheet(isPresented: $isAddingNote) {
                    AddNoteView(viewModel: viewModel)
                },
                alignment: .bottomTrailing // 📌 Sağ alt köşeye sabitle
            )
        }
    }

    // 🔹 **Not Kartı**
    @ViewBuilder
    private func noteCard(note: Note) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.text ?? "Boş Not")
                .font(.body)
                .padding()
                .foregroundColor(.black)

            HStack {
                if let reminderDate = note.reminderDate {
                    Text("Hatırlatma: \(reminderDate, style: .date) \(reminderDate, style: .time)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }

                Spacer()

                Button(action: {
                    speakText(note.text ?? "")
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                }

                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        viewModel.deleteNote(note: note)
                        if let id = note.id {
                            NotificationManager.shared.removeNotification(identifier: UUID().uuidString)
                        }
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(.trailing, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat.random(in: 130...400)) 
        .background(Color.fromHex(note.colorHex ?? "#FFFF00"))
        .cornerRadius(15)
    }

    // 🔊 **Notu Sesli Okuma**
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
    NoteView(context: PersistenceController.shared.context)
}
