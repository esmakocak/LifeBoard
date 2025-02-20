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
            ZStack {
                ScrollView {
                    VStack(spacing: 15) {
                        if viewModel.medicines.isEmpty {
                            // 📌 Eğer hiç ilaç yoksa boş mesaj göster
                            VStack {
                                Image(systemName: "pills.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("No Medicines Added")
                                    .font(.headline)
                                    .foregroundColor(.gray.opacity(0.7))
                                    .padding(.top, 5)
                            }
                            .frame(maxWidth: .infinity, minHeight: 450) 
                        } else {
                            ForEach(viewModel.medicines) { medicine in
                                MedicineCardView(medicine: medicine, viewModel: viewModel)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Medicines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mock Data Ekle") {
                        viewModel.addMockData()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                // 📌 FAB butonunun sabit kalmasını sağla
                HStack {
                    Spacer()
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
                    .padding(.bottom, 16)
                    .padding(.trailing, 16)
                }
            }
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
                
                HStack(spacing: 20) {
                    
                    if let imageData = medicine.imageData, let uiImage = UIImage(data: imageData) {
                        //  Kullanıcının yüklediği resmi göster
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        //  Eğer resim yüklenmemişse varsayılan "pill" ikonunu göster
                        Image(systemName: "pills")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color("darkBlue"))
                            .padding(15)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }

                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(medicine.name ?? "Unknown Medicine")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        Text("\(medicine.days ?? "") | \(medicine.time ?? "")")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.7))
                    }
                    
                    Spacer()
                } .padding(.bottom, 5)
                
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
