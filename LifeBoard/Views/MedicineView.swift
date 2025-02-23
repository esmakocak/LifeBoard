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
    @State private var isAddingMedicine = false
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @Environment(\.scenePhase) private var scenePhase
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MedicineViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    
                    // MARK: Daily Medicines Button
                    Button(action: {
                        let todayMedicines = viewModel.getMedicinesForToday()
                        if todayMedicines.isEmpty {
                            alertMessage = "You have no medicines to take today."
                        } else {
                            let medicineNames = todayMedicines.map { $0.name ?? "Unknown" }.joined(separator: ", ")
                            alertMessage = "Today you should take: \(medicineNames)"
                        }
                        isShowingAlert = true
                    }) {
                        Text("What should I take today?")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("lightBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding(.horizontal)
                    .alert("Today's Medicines", isPresented: $isShowingAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(alertMessage)
                    }
                    
                    ScrollView {
                        
                        VStack(spacing: 15) {
                            if viewModel.medicines.isEmpty {
                                VStack {
                                    Text("No Medicines Added Yet")
                                        .font(.headline)
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity, minHeight: 500)
                            } else {
                                ForEach(viewModel.medicines) { medicine in
                                    MedicineCardView(medicine: medicine, viewModel: viewModel)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Medicines")
            .onAppear {
                viewModel.checkAndResetTakenStatus()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    viewModel.checkAndResetTakenStatus()
                }
            }
            .safeAreaInset(edge: .bottom) {
                // MARK: Add Button
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
        }
        .sheet(isPresented: $isAddingMedicine) {
            AddMedicineView(viewModel: viewModel)
        }
    }
}

#Preview {
    MedicineView(context: PersistenceController.shared.context)
}

// MARK: Medicine Card
struct MedicineCardView: View {
    let medicine: Medicine
    @ObservedObject var viewModel: MedicineViewModel
    
    @State private var isImageFullScreen = false // For open image full screen
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                
                HStack(spacing: 20) {
                    
                    if let imageData = medicine.imageData, let uiImage = UIImage(data: imageData) {
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .onTapGesture {
                                isImageFullScreen = true
                            }
                    } else {
                        
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
                        
                        Text("\(viewModel.getDaysFromBitmask(medicine.daysBitmask).joined(separator: ", ")) | \(medicine.time ?? "")")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.7))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 5)
                
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
        .fullScreenCover(isPresented: $isImageFullScreen) {
            if let imageData = medicine.imageData, let uiImage = UIImage(data: imageData) {
                ZStack {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        Spacer()
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                isImageFullScreen = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
