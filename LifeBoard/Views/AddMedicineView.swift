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
                    
                    // **Günler**
                    Text("Date")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                    
                    TextField("Days (e.g. Mon, Wed, Fri)", text: $days)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .padding(.bottom, 10)
                    
                    
                    // **Saat**
                    Text("Time")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                    
                    TextField("Time (e.g. 08:30)", text: $time)
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
                            if !name.isEmpty {
                                let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
                                viewModel.addMedicine(name: name, days: days, time: time, imageData: imageData)
                                dismiss()
                            }
                        }) {
                            Text("Save")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .padding()
                                .frame(width: 150)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        .disabled(name.isEmpty)
                        
                        Spacer()
                        
                    } .padding()
                    
                    
                    
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
