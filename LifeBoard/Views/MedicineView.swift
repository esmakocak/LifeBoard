//
//  MedicineView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//
import SwiftUI
import CoreData

struct MedicineView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: MedicineViewModel
    @State private var isAddingMedicine = false // Sheet açma kontrolü
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MedicineViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.medicines) { medicine in
                        MedicineCardView(medicine: medicine, viewModel: viewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("Medicines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mock Data Ekle") {
                        viewModel.addMockData()
                    }
                }
            }
            .overlay(
                //  **Floating Action Button (FAB)**
                Button(action: {
                    isAddingMedicine = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .bold))
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                    .padding(),
                alignment: .bottomTrailing
            )
            .sheet(isPresented: $isAddingMedicine) {
                AddMedicineView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    MedicineView(context: PersistenceController.shared.context)
}


struct MedicineCardView: View {
    let medicine: Medicine
    @ObservedObject var viewModel: MedicineViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                
                // MARK: Medicine; İmage, Name, Dates
                HStack {
                    if let imageName = medicine.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(medicine.name ?? "Unknown Medicine")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .bold()
                        
                        Text("\(medicine.days ?? "") | \(medicine.time ?? "")")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    
                    Spacer()
                }
                
                // MARK: Taken Button
                Button(action: {
                    viewModel.toggleTaken(medicine: medicine)
                }) {
                    Text(medicine.isTaken ? "Taken" : "Take")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(medicine.isTaken ? Color("darkBlue") : Color.clear)
                        .foregroundColor(medicine.isTaken ? .white : Color("darkBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("darkBlue"), lineWidth: medicine.isTaken ? 0 : 2)
                        )
                }
            }
            .padding()
            .background(Color("lightBlue").opacity(0.9))
            .cornerRadius(20)
            
            // MARK: Delete Button 
            Button(action: {
                viewModel.deleteMedicine(medicine: medicine)
            }) {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundColor(Color("darkBlue"))
                    .padding(8)
            }
            .padding(10)
        }
    }
}
