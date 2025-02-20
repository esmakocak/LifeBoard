//
//  MedicineViewModel.swift
//  LifeBoard
//
//  Created by Esma Koçak on 19.02.2025.
//

import Foundation
import CoreData

class MedicineViewModel: ObservableObject {
    @Published var medicines: [Medicine] = []
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchMedicines()
        
        //  Eğer Core Data boşsa, mock data ekle , SİL !!
        if medicines.isEmpty {
            addMockData()
        }
    }
    
    // **Tüm ilaçları Core Data'dan getir**
    func fetchMedicines() {
        let request: NSFetchRequest<Medicine> = Medicine.fetchRequest()
        
        do {
            medicines = try viewContext.fetch(request)
        } catch {
            print("Hata: Core Data'dan verileri çekerken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    // **Mock Data Ekleyen Fonksiyon** SİL !!
    func addMockData() {
        let mockMedicines = [
            ("Duopezil", "Sun, Mon, Tue", "20:00", "pill"),
            ("Aduhelm", "Wed", "13:30", "syrup"),
            ("Metformin", "Mon, Thu", "08:00", "injection")
        ]
        
        for (name, days, time, imageName) in mockMedicines {
            let newMedicine = Medicine(context: viewContext)
            newMedicine.id = UUID()
            newMedicine.name = name
            newMedicine.days = days
            newMedicine.time = time
            newMedicine.imageName = imageName
            newMedicine.isTaken = false
        }
        
        saveContext()
        fetchMedicines()
    }
    
    // **Yeni ilaç ekle**
    func addMedicine(name: String, days: String, time: String, imageName: String) {
        let newMedicine = Medicine(context: viewContext)
        newMedicine.id = UUID()
        newMedicine.name = name
        newMedicine.days = days
        newMedicine.time = time
        newMedicine.imageName = imageName
        newMedicine.isTaken = false
        
        saveContext()
    }
    
    // **İlacı sil**
    func deleteMedicine(medicine: Medicine) {
        viewContext.delete(medicine)
        saveContext()
    }
    
    // **İlaç durumunu güncelle ("Taken" toggle)**
    func toggleTaken(medicine: Medicine) {
        medicine.isTaken.toggle()
        saveContext()
    }
    
    // **Core Data'da değişiklikleri kaydet**
    private func saveContext() {
        do {
            try viewContext.save()
            fetchMedicines()
        } catch {
            print("Hata: Core Data kaydetme başarısız \(error.localizedDescription)")
        }
    }
}
