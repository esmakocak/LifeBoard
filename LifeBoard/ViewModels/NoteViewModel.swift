//
//  NoteViewModel.swift
//  LifeBoard
//
//  Created by Esma Koçak on 10.02.2025.
//

import Foundation
import CoreData
import SwiftUI

class NoteViewModel: ObservableObject {
    let context: NSManagedObjectContext
    
    @Published var notes: [Note] = [] // store notes from CoreData
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchNotes()
    }
    
    // Add Note
    func addNote(text: String, subtext: String, color: Color, id: String, date: Date? = nil) {
        let newNote = Note(context: context)
        newNote.id = UUID()
        newNote.text = text
        newNote.subtext = subtext
        newNote.colorHex = color.toHex()
        newNote.date = Date()
        newNote.reminderDate = date
        
        saveContext()
        fetchNotes()
    }
    
    // Fetch Notes
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // Keep the last note at the top
        
        do {
            notes = try context.fetch(request)
        } catch {
            assertionFailure("Notları çekerken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    // Delete Note
    func deleteNote(note: Note) {
        context.delete(note)
        saveContext()
        fetchNotes()
    }
    
    // Update Note
    func updateNote(note: Note, text: String, subtext: String, color: Color) {
        note.text = text
        note.subtext = subtext
        note.colorHex = color.toHex()
        
        saveContext()
        fetchNotes()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            assertionFailure("Kaydetme hatası: \(error.localizedDescription)")
        }
    }
}
