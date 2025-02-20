//
//  AddMedicineView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 20.02.2025.
//

import SwiftUI

struct AddMedicineView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MedicineViewModel
    
    @State private var name = ""
    @State private var days = ""
    @State private var time = Date()
    @State private var imageName = "pill"
    
    let images = ["pill", "syrup", "injection"] // 📌 Örnek resimler
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Medicine Details")) {
                    TextField("Medicine Name", text: $name)
                    
                    TextField("Days (e.g. Mon, Wed, Fri)", text: $days)
                    
                    DatePicker("Time", selection: $time, displayedComponents: [.hourAndMinute])
                }
                
                Section(header: Text("Select Image")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(images, id: \.self) { img in
                                Image(img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(imageName == img ? Color.blue : Color.clear, lineWidth: 2)
                                    )       

                                    .onTapGesture {
                                        imageName = img
                                    }
                            }
                        }
                    }
                }
                
                Button("Add Medicine") {
                    let timeFormatter = DateFormatter()
                    timeFormatter.timeStyle = .short
                    let formattedTime = timeFormatter.string(from: time)
                    
                    viewModel.addMedicine(
                        name: name,
                        days: days,
                        time: formattedTime,
                        imageName: imageName
                    )
                    dismiss()
                }
                .disabled(name.isEmpty || days.isEmpty)
                .frame(maxWidth: .infinity)
                .padding()
                .background(name.isEmpty || days.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Add Medicine")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
