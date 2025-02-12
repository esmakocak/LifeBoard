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
            VStack {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.notes) { note in
                            noteCard(note: note)
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
                    AddNoteView(viewModel: viewModel)
                }

                Spacer()
            }
            .navigationTitle("Notes")
            .onAppear {
                NotificationManager.shared.requestNotificationPermission() //  Bildirim izni iste
            }
        }
    }

    // 🔹 CoreData'dan gelen notları gösteren kart
    @ViewBuilder
    private func noteCard(note: Note) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.text ?? "Boş Not")
                .font(.body)
                .padding()
                .foregroundColor(.black)

            HStack {
                // 🔔 **Hatırlatma Tarihi Göster**
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
                        
                        // 📌 **Bildirimi de Sil**
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.fromHex(note.colorHex ?? "#FFFF00"))
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
    NoteView(context: PersistenceController.shared.context)
}
