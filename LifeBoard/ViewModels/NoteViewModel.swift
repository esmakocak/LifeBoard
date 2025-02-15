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
            createMockNote(text: "Dişçi Randevusu", subtext: "Yarın 10:30'da randevum var.", colorHex: "#bde0fe", reminder: nil),
            createMockNote(text: "Toplantı Notları", subtext: "Pazartesi yapılacak olan ekip toplantısına hazırlık.", colorHex: "#e2c4f2", reminder: nil),
            createMockNote(text: "Alışveriş Listesi", subtext: "Süt, ekmek, yumurta, peynir, kahve", colorHex: "#ffc8dd", reminder: nil),
            createMockNote(text: "Alışveriş Listesi", subtext: "Yarın 10:30'da randevum var.", colorHex: "#ffc8dd", reminder: nil),
            createMockNote(text: "Toplantı Notları",subtext: "Pazartesi yapılacak olan ekip toplantısına hazırlık.", colorHex: "#e2c4f2", reminder: nil),
            createMockNote(text: "Dişçi Randevusu", subtext: "Süt, ekmek, yumurta, peynir, kahve", colorHex: "#bde0fe", reminder: nil),
        ]
    }

    private func createMockNote(text: String, subtext: String ,colorHex: String, reminder: Date?) -> Note {
        let newNote = Note(context: context)
        newNote.id = UUID()
        newNote.text = text
        newNote.subtext = subtext
        newNote.colorHex = colorHex
        newNote.reminderDate = reminder
        newNote.date = Date()
        return newNote
    }
    
    
}
