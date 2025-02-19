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
    var noteToEdit: Note?

    let colors: [Color] = [Color("lightPink"), Color("lightPurple"), Color("lightBlue")]

    init(viewModel: NoteViewModel, noteToEdit: Note? = nil) {
        self.viewModel = viewModel
        self.noteToEdit = noteToEdit

        _newNote = State(initialValue: noteToEdit?.text ?? "")
        _newSubtext = State(initialValue: noteToEdit?.subtext ?? "")
        _selectedColor = State(initialValue: Color.fromHex(noteToEdit?.colorHex ?? "#FFFF00"))
        _isReminderOn = State(initialValue: noteToEdit?.reminderDate != nil)
        _reminderDate = State(initialValue: noteToEdit?.reminderDate ?? Date())
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(noteToEdit == nil ? "Add Note" : "Edit Note")
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)
                
                NoteTextField(title: "Note Title", text: $newNote)
                NoteTextEditor(title: "Note Detail", text: $newSubtext)
                
                ColorPickerView(selectedColor: $selectedColor, colors: colors).padding(.bottom)
                
                ReminderToggle(isReminderOn: $isReminderOn, reminderDate: $reminderDate, showAlert: $showAlert).padding(.bottom)
                
                SaveButton(action: saveNote, isDisabled: newNote.isEmpty, isEditing: noteToEdit != nil)
            }
            .padding()
        }
        .onAppear { notificationManager.checkNotificationStatus() }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            notificationManager.checkNotificationStatus()
        }
        .alert("Bildirimlere İzin Verilmedi", isPresented: $showAlert) {
            Button("Ayarları Aç") { notificationManager.openAppSettings() }
            Button("Tamam", role: .cancel) {}
        } message: {
            Text("Hatırlatma eklemek için bildirimlere izin vermelisiniz.")
        }
    }

    private func saveNote() {
        if let noteToEdit = noteToEdit {
            viewModel.updateNote(
                note: noteToEdit,
                text: newNote,
                subtext: newSubtext,
                color: selectedColor
            )
            manageNotification(id: noteToEdit.id?.uuidString ?? UUID().uuidString)
        } else {
            let id = UUID().uuidString
            viewModel.addNote(
                text: newNote,
                subtext: newSubtext,
                color: selectedColor,
                id: id,
                date: isReminderOn ? reminderDate : nil
            )
            manageNotification(id: id)
        }
        dismiss()
    }

    private func manageNotification(id: String) {
        if isReminderOn {
            NotificationManager.shared.scheduleNotification(id: id, note: newNote, date: reminderDate)
        } else {
            NotificationManager.shared.removeNotification(identifier: id)
        }
    }
}

struct NoteTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.body)
                .bold()
                .foregroundColor(.black.opacity(0.7))
            TextField("Başlık giriniz..", text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
        }
    }
}

struct NoteTextEditor: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.body)
                .bold()
                .foregroundColor(.black.opacity(0.7))
            TextEditor(text: $text)
                .padding()
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    let colors: [Color]
    
    var body: some View {
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
                    .onTapGesture { selectedColor = color }
            }
        }
    }
}

struct ReminderToggle: View {
    @Binding var isReminderOn: Bool
    @Binding var reminderDate: Date
    @Binding var showAlert: Bool
    
    var body: some View {
        Toggle(isOn: $isReminderOn) {
            Text("Add Reminder")
                .font(.body)
                .bold()
                .foregroundColor(.black.opacity(0.7))
        }
        .onChange(of: isReminderOn) { newValue in
            if newValue && !NotificationManager.shared.isNotificationAllowed {
                isReminderOn = false
                showAlert = true
            }
        }
        if isReminderOn {
            HStack {
                Text("Reminder Time")
                    .font(.body)
                    .bold()
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
                DatePicker("", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct SaveButton: View {
    let action: () -> Void
    let isDisabled: Bool
    let isEditing: Bool
    
    var body: some View {
        Button(action: action) {
            Text(isEditing ? "Güncelle" : "Kaydet")
                .padding()
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .frame(width: 150)
                .background(isDisabled ? Color.black.opacity(0.7) : Color.black)
                .foregroundColor(.white)
                .cornerRadius(20)
        }
        .disabled(isDisabled)
    }
}
