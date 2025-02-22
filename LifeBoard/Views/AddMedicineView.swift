//
//  AddMedicineView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 20.02.2025.
//

import SwiftUI
import PhotosUI

struct AddMedicineView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MedicineViewModel
    
    @State private var name: String = ""
    @State private var days: String = ""
    @State private var time: String = ""
    @State private var selectedImage: UIImage? // Kullanıcıdan seçilen resim
    @State private var isImagePickerPresented = false
    
    @State private var selectedDays: [String] = []

    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Add Medicine")
                    .font(.title2)
                    .bold()
                    .padding(.top,20)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    // **İlaç Adı**
                    Text("Medicine Name")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                    
                    TextField("Medicine Name..", text: $name)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                    
                    
                    Text("Frequency")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                    
                    DaySelectionView(selectedDays: $selectedDays).padding(.bottom, 10)
                    
                    
                    // **Saat**
                    Text("Note")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                    
                    TextField("Twice a day, nights, at 08:30 etc..", text: $time)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                    
                    // **Resim Seçme **
                    Text("Medicine Photo")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                    
                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        VStack {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                                    .frame(width: 150, height: 150)
                            } else {
                                VStack {
                                    Image(systemName: "photo.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.black.opacity(0.6))
                                    
                                    Text("Select Image")
                                        .bold()
                                        .foregroundStyle(.black.opacity(0.6))
                                }
                                
                            }
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    
                    // **İlaç Ekle Butonu**
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            if !name.isEmpty && !selectedDays.isEmpty {
                                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                                viewModel.addMedicine(name: name, selectedDays: selectedDays, time: time, imageData: imageData)
                                dismiss()
                            }
                        }) {
                            Text("Save")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .padding()
                                .frame(width: 150)
                                .background((!name.isEmpty && !selectedDays.isEmpty) ? Color.black : Color.black.opacity(0.7) )
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .disabled(name.isEmpty || selectedDays.isEmpty) // Kullanıcı ilaç ismi ve günleri seçmedikçe buton devre dışı
                        
                        Spacer()
                    }
                    .padding()
                    
                    
                    
                    Spacer()
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: $selectedImage)
                }
                
            }
        }
    }
}


struct DaySelectionView: View {
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @Binding var selectedDays: [String]

    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7) // 📌 7 sütun

    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) { // 📌 7 eşit sütun
            ForEach(days, id: \.self) { day in
                Button(action: {
                    if selectedDays.contains(day) {
                        selectedDays.removeAll { $0 == day }
                    } else {
                        selectedDays.append(day)
                    }
                }) {
                    Text(day.prefix(3)) // "Mon", "Tue" gibi göster
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .frame(width: 40, height: 40) 
                        .background(selectedDays.contains(day) ? Color("darkPurple") : Color.gray.opacity(0.2))
                        .foregroundColor(selectedDays.contains(day) ? .white : .black.opacity(0.7))
                        .clipShape(Circle()) // 📌 Daire buton
                }
            }
        }
    }
}
