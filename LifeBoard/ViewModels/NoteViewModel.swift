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
        loadMockData() // 📌 Şimdilik mock verileri yüklüyoruz, sonra silebilirsin. !!!!!!!!!!
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
    
    // 🔹 **Mock Verileri Yükleme (Geçici)** !!!!!!!!!!!!!!!!!!!!!
    private func loadMockData() {
        notes = [
            createMockNote(text: "Alışveriş Listesi", colorHex: "#ffc8dd", reminder: nil),
            createMockNote(text: "Toplantı Notları", colorHex: "#e2c4f2", reminder: nil),
            createMockNote(text: "Dişçi Randevusu", colorHex: "#bde0fe", reminder: nil),
            createMockNote(text: "Alışveriş Listesi", colorHex: "#ffc8dd", reminder: nil),
            createMockNote(text: "Toplantı Notları", colorHex: "#e2c4f2", reminder: nil),
            createMockNote(text: "Dişçi Randevusu", colorHex: "#bde0fe", reminder: nil),
        ]
    }

    private func createMockNote(text: String, colorHex: String, reminder: Date?) -> Note {
        let newNote = Note(context: context)
        newNote.id = UUID()
        newNote.text = text
        newNote.colorHex = colorHex
        newNote.reminderDate = reminder
        newNote.date = Date()
        return newNote
    }
    
    
}
