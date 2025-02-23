//
//  NoteDetailView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 18.02.2025.
//
import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var viewModel: NoteViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isEditing = false
    
    var body: some View {
        let backgroundColor = Color.fromHex(note.colorHex ?? "#FFFF00")
        let iconColor = Color.getDarkColor(for: note.colorHex ?? "#FFFF00")
        
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .font(.title2)
                            .foregroundColor(iconColor)
                            .bold()
                            .padding(10)
                            .background(iconColor.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    Button {
                        isEditing = true // Editing screen
                    } label : {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(iconColor)
                            .bold()
                            .padding(10)
                            .background(iconColor.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button {
                        withAnimation {
                            viewModel.deleteNote(note: note)
                            dismiss()
                        }
                    } label : {
                        Image(systemName: "trash.fill")
                            .font(.title2)
                            .foregroundColor(iconColor)
                            .bold()
                            .padding(10)
                            .background(iconColor.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(note.text ?? "Boş Not")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(iconColor)
                            .padding(.top, 5)
                        
                        if let subtext = note.subtext, !subtext.isEmpty {
                            Text(subtext)
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            
            WaveShape()
                .fill(backgroundColor)
                .frame(height: 190)
            
            WaveShape()
                .fill(iconColor.opacity(0.8))
                .frame(height: 150)
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $isEditing) {
            AddNoteView(viewModel: viewModel, noteToEdit: note)
        }
    }
}

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.25))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.75))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY) )
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY) )
        }
    }
}
