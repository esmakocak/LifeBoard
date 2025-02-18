import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NoteViewModel
    @ObservedObject var notificationManager = NotificationManager.shared
    
    @State private var newNote = ""
    @State private var newSubtext = ""
    @State private var selectedColor: Color = Color("lightPink")
    @State private var isReminderOn: Bool = false
    @State private var reminderDate: Date = Date()
    @State private var showAlert: Bool = false
    var noteToEdit: Note? // ✅ Düzenlenecek not (Opsiyonel)

    let colors: [Color] = [Color("lightPink"), Color("lightPurple"), Color("lightBlue")]

    init(viewModel: NoteViewModel, noteToEdit: Note? = nil) {
        self.viewModel = viewModel
        self.noteToEdit = noteToEdit

        // ✅ Mevcut not varsa, state'leri başlangıç değerleriyle doldur
        _newNote = State(initialValue: noteToEdit?.text ?? "")
        _newSubtext = State(initialValue: noteToEdit?.subtext ?? "")
        _selectedColor = State(initialValue: Color.fromHex(noteToEdit?.colorHex ?? "#FFFF00"))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text(noteToEdit == nil ? "Add Note" : "Edit Note") // ✅ Dinamik başlık
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)
                
                // 🔹 **Not Başlığı**
                VStack(alignment: .leading, spacing: 7) {
                    Text("Note Title")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                        .padding(8)
                    
                    TextField("Başlık giriniz..", text: $newNote)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                                
                // 🔹 **Not İçeriği**
                VStack(alignment: .leading, spacing: 5) {
                    Text("Note Detail")
                        .font(.body)
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                        .padding(8)
                    
                    TextEditor(text: $newSubtext)
                        .padding()
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                }
                
                
                // 🔹 **Not Rengi**
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Choose Color")
                            .font(.body)
                            .bold()
                            .foregroundColor(.black.opacity(0.7))
                        
                        Spacer()
                        
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 1)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                    .padding(8)
                    .cornerRadius(10)
                }

                // 🔹 **Hatırlatma**
                VStack(alignment: .leading, spacing: 5) {
                    Toggle(isOn: $isReminderOn) {
                        Text("Add Reminder")
                            .font(.body)
                            .bold()
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(8)
                    .onChange(of: isReminderOn) { newValue in
                        if newValue && !notificationManager.isNotificationAllowed {
                            isReminderOn = false
                            showAlert = true
                        }
                    }
                    
                    if isReminderOn {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Reminder Time")
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.black.opacity(0.7))
                                    .padding(.leading, 8)
                                
                                Spacer()
                                
                                DatePicker("", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                
                // 🔹 **Kaydet / Güncelle Butonu**
                Button {
                    if let noteToEdit = noteToEdit {
                        // ✅ Mevcut notu güncelle
                        viewModel.updateNote(
                            note: noteToEdit,
                            text: newNote,
                            subtext: newSubtext,
                            color: selectedColor
                        )
                    } else {
                        // ✅ Yeni not ekle
                        let id = UUID().uuidString
                        viewModel.addNote(
                            text: newNote,
                            subtext: newSubtext,
                            color: selectedColor,
                            id: id,
                            date: isReminderOn ? reminderDate : nil
                        )
                    }
                    dismiss()
                } label: {
                    Text(noteToEdit == nil ? "Kaydet" : "Güncelle")
                        .padding()
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .frame(width: 150)
                        .background(newNote.isEmpty ? Color.black.opacity(0.7) : Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .disabled(newNote.isEmpty)
                .padding(.top, 20)
            }
            .padding()
        }
        .background(Color("lightGray"))
        .onAppear {
            notificationManager.checkNotificationStatus()
        }
        .alert("Bildirimlere İzin Verilmedi", isPresented: $showAlert) {
            Button("Ayarları Aç") {
                notificationManager.openAppSettings()
            }
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("Hatırlatma eklemek için bildirimlere izin vermelisiniz.")
        }
    }
}
