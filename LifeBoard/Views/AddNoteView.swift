import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NoteViewModel

    @State private var newNote = ""  // Kullanıcının notu
    @State private var selectedColor: Color = .yellow // Varsayılan renk
    @State private var isReminderOn: Bool = false // 🔔 Hatırlatma Aç/Kapat
    @State private var reminderDate: Date = Date() // ⏰ Hatırlatma Zamanı

    let colors: [Color] = [.yellow, .purple, .green, .blue, .orange, .pink]

    var body: some View {
        VStack {
            Text("Yeni Not")
                .font(.title)
                .padding()

            TextField("Notunuzu yazın...", text: $newNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // 🔹 Renk Seçme Alanı
            HStack {
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .padding()

            // 🔔 **Hatırlatma Toggle'ı**
            Toggle("Hatırlatma Ekle", isOn: $isReminderOn)
                .padding()

            // ⏰ **Tarih ve Saat Seçici**
            if isReminderOn {
                DatePicker("Hatırlatma Zamanı", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    .padding()
            }

            Button {
                if !newNote.isEmpty {
                    let id = UUID().uuidString  // 📌 Her nota benzersiz ID ata
                    
                    // 📌 **Notu kaydet**
                    viewModel.addNote(text: newNote, color: selectedColor, id: id, date: isReminderOn ? reminderDate : nil)
                    
                    // 📌 **Bildirim ayarla**
                    if isReminderOn {
                        NotificationManager.shared.scheduleNotification(id: id, note: newNote, date: reminderDate)
                    }
                }
                dismiss()  // Sheet’i kapat
            } label: {
                Text("Kaydet")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }
}
