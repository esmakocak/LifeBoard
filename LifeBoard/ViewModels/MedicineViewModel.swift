//
//  MedicineViewModel.swift
//  LifeBoard
//
//  Created by Esma Koçak on 19.02.2025.
//

import Foundation
import CoreData
import UIKit

class MedicineViewModel: ObservableObject {
    @Published var medicines: [Medicine] = []
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchMedicines()
    }
    
    // **Tüm ilaçları getir**
    func fetchMedicines() {
        let request: NSFetchRequest<Medicine> = Medicine.fetchRequest()
        
        // Sıralama: Eklenme zamanı en yeni olan en üstte olsun
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            medicines = try viewContext.fetch(request)
        } catch {
            print("Error fetching medicines: \(error.localizedDescription)")
        }
    }
    
    // **Yeni ilaç ekle**
    func addMedicine(name: String, selectedDays: [String], time: String, imageData: Data?) {
        let newMedicine = Medicine(context: viewContext)
        newMedicine.id = UUID()
        newMedicine.name = name
        newMedicine.daysBitmask = selectedDays.reduce(0) { bitmask, day in
            guard let index = weekDays.firstIndex(of: day) else { return bitmask }
            return bitmask | (1 << index)
        }
        newMedicine.time = time
        newMedicine.imageData = imageData
        newMedicine.isTaken = false
        saveContext()
    }
    
    func getDaysFromBitmask(_ bitmask: Int16) -> [String] {
        return weekDays.enumerated().compactMap { index, day in
            (bitmask & (1 << index)) != 0 ? day : nil
        }
    }
    
    func getMedicinesForToday() -> [Medicine] {
        let todayIndex = Calendar.current.component(.weekday, from: Date()) - 1
        return medicines.filter { $0.daysBitmask & (1 << todayIndex) != 0 }
    }
    
    // **İlaç sil**
    func deleteMedicine(medicine: Medicine) {
        viewContext.delete(medicine)
        saveContext()
    }
    
    // **İlaç durumunu güncelle**
    func toggleTaken(medicine: Medicine) {
        medicine.isTaken.toggle()
        saveContext()
    }
    
    // **Mock Data Ekle**
    func addMockData() {
        let mockMedicines = [
            ("Aspirin", ["Mon", "Wed", "Fri"], "08:00", UIImage(named: "aspirin")),
            ("Paracetamol", ["Tue", "Thu"], "14:30", UIImage(named: "paracetamol")),
            ("Ibuprofen", ["Sat", "Sun"], "20:00", UIImage(named: "ibuprofen"))
        ]
        
        for (name, days, time, image) in mockMedicines {
            let imageData = image?.jpegData(compressionQuality: 0.8) // Resmi Data'ya çevir
            addMedicine(name: name, selectedDays: days, time: time, imageData: imageData)
        }
    }
    
    // **CoreData'da değişiklikleri kaydet**
    private func saveContext() {
        do {
            try viewContext.save()
            fetchMedicines()
        } catch {
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }
}
