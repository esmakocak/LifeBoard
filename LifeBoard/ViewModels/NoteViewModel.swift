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

    @Published var notes: [Note] = [] // 📌 CoreData’dan gelen notları burada tutacağız
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchNotes() // 📌 Uygulama açıldığında CoreData'dan notları çek
    }
    
    func addNote(text: String, color: Color, id: String, date: Date? = nil) {
        let newNote = Note(context: context)
        newNote.id = UUID()
        newNote.text = text
        newNote.colorHex = color.toHex()
        newNote.date = Date() // Notun eklendiği tarih
        newNote.reminderDate = date // 📌 Hatırlatma tarihini kaydet

        saveContext()
        fetchNotes() // 📌 Güncellenmiş veriyi çek

    }
    
    // ✅ CoreData'dan Notları Çekme
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // En yeni not en üstte olsun
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Notları çekerken hata oluştu: \(error.localizedDescription)")
        }
    }

    // ✅ CoreData'dan Not Silme
    func deleteNote(note: Note) {
        context.delete(note)
        saveContext()
        fetchNotes()
    }

    // ✅ CoreData'ya Değişiklikleri Kaydetme
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Kaydetme hatası: \(error.localizedDescription)")
        }
    }
}
