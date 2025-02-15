//
//  NoteView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI
import CoreData

struct NoteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: NoteViewModel

    @State private var isAddingNote = false

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: NoteViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    HStack(alignment: .top, spacing: 10) {
                        // Sol sütun
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.notes.enumerated().filter { $0.offset.isMultiple(of: 2) }.map { $0.element }) { note in
                                noteCard(note: note)
                            }
                        }

                        // Sağ sütun
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.notes.enumerated().filter { !$0.offset.isMultiple(of: 2) }.map { $0.element }) { note in
                                noteCard(note: note)
                            }
                        }
                    }
                    .padding()
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
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .padding()
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
                        
            if let subtext = note.subtext, !subtext.isEmpty {
                Text(subtext)
                    .font(.headline)
                    .foregroundColor(.black.opacity(0.7))
                    .lineLimit(3)
                    .truncationMode(.tail)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            HStack {

                Spacer()

                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        viewModel.deleteNote(note: note)
                        if let id = note.id {
                            NotificationManager.shared.removeNotification(identifier: UUID().uuidString)
                        }
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(Color.black.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.trailing, 8)
            .padding(.bottom, 8)
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat.random(in: 200...350))
        .background(Color.fromHex(note.colorHex ?? "#FFFF00"))
        .cornerRadius(15)
    }

}

#Preview {
    NoteView(context: PersistenceController.shared.context)
}
