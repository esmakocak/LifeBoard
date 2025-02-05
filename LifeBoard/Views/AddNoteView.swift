//
//  AddNoteView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI
import AVFoundation

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var notes: [String]  // Ana ekrana veri göndermek için Binding

    @State private var newNote = ""  // Yeni not girişi

    var body: some View {
        VStack {
            Text("Yeni Not")
                .font(.title)
                .padding()

            TextField("Notunuzu yazın...", text: $newNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Kaydet") {
                if !newNote.isEmpty {
                    notes.append(newNote)  // Yeni notu listeye ekle
                }
                dismiss()  // Sheet’i kapat
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
