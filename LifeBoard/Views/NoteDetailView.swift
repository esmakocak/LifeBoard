//
//  NoteDetailView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 18.02.2025.
//

import SwiftUI

struct NoteDetailView: View {
    let note: Note
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(note.text ?? "Boş Not")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            
            if let subtext = note.subtext, !subtext.isEmpty {
                Text(subtext)
                    .font(.body)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 5)
            }
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
    }
}
