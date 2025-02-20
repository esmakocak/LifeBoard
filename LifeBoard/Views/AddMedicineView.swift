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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // **İlaç Adı**
                TextField("Medicine Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // **Günler**
                TextField("Days (e.g. Mon, Wed, Fri)", text: $days)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // **Saat**
                TextField("Time (e.g. 08:30)", text: $time)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                // **Resim Seçme Butonu**
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    VStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.blue)
                        }
                        Text("Select Image")
                            .font(.headline)
                    }
                }
                
                // **İlaç Ekle Butonu**
                Button(action: {
                    if !name.isEmpty {
                        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                        viewModel.addMedicine(name: name, days: days, time: time, imageData: imageData)
                        dismiss()
                    }
                }) {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .disabled(name.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Medicine")
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}
