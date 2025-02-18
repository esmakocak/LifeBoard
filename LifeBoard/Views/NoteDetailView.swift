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
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .font(.title2)
                        .foregroundColor(Color("darkPink"))
                        .bold()
                        .padding(10)
                        .background(Color.darkPink.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(.leading, 10)
                
                Spacer()
                
                Button {
                    
                } label : {
                    Image(systemName: "pencil")
                        .font(.title2)
                        .foregroundColor(Color("darkPink"))
                        .bold()
                        .padding(10)
                        .background(Color.darkPink.opacity(0.2))
                        .clipShape(Circle())
                }
                
                Button {
                    
                } label : {
                    Image(systemName: "trash.fill")
                        .font(.title2)
                        .foregroundColor(Color("darkPink"))
                        .bold()
                        .padding(10)
                        .background(Color.darkPink.opacity(0.2))
                        .clipShape(Circle())
                }
            }

            // Başlık
            Text(note.text ?? "Boş Not")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.top, 5)
            
            // İçerik
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.fromHex(note.colorHex ?? "#FFFF00"))
    }
}
