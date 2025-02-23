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
    @State private var searchText: String = ""
    @State private var selectedNote: Note?
    @State private var isDetailPresented = false
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: NoteViewModel(context: context))
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return viewModel.notes
        } else {
            return viewModel.notes.filter {
                $0.text?.localizedCaseInsensitiveContains(searchText) == true ||
                $0.subtext?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    SearchBar()
                        .padding(.horizontal)
                        .padding(.top)
                    
                    ScrollView {
                        if filteredNotes.isEmpty {
                            VStack {
                                Text("No Notes Found")
                                    .font(.headline)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity, minHeight: 500)
                        } else {
                            HStack(alignment: .top, spacing: 10) {
                                // MARK: Columns
                                LazyVStack(spacing: 10) {
                                    ForEach(filteredNotes.enumerated().filter { $0.offset.isMultiple(of: 2) }.map { $0.element }) { note in
                                        noteCard(note: note)
                                    }
                                }
                                
                                LazyVStack(spacing: 10) {
                                    ForEach(filteredNotes.enumerated().filter { !$0.offset.isMultiple(of: 2) }.map { $0.element }) { note in
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
            }
            .overlay(
                // MARK: Add Button
                Button(action: {
                    isAddingNote = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .bold))
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                    .padding()
                    .sheet(isPresented: $isAddingNote) {
                        AddNoteView(viewModel: viewModel)
                    },
                alignment: .bottomTrailing
            )
        }
        .fullScreenCover(item: $selectedNote) { note in
            NoteDetailView(note: note, viewModel: viewModel)
        }
    }
    
    // MARK: Note Card
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
                    .truncationMode(.tail)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            HStack {
                Spacer()
            }
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .frame(height: CGFloat.random(in: 200...330))
        .background(Color.fromHex(note.colorHex ?? "#FFC8DD"))
        .cornerRadius(15)
        .onTapGesture {
            selectedNote = note
            isDetailPresented = true
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: Search Bar
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search..", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .autocorrectionDisabled()
                .padding(.leading, 5)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    NoteView(context: PersistenceController.shared.context)
}
