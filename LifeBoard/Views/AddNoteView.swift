import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NoteViewModel
    @ObservedObject var notificationManager = NotificationManager.shared

    @State private var newNote = ""
    @State private var selectedColor: Color = .yellow
    @State private var isReminderOn: Bool = false
    @State private var reminderDate: Date = Date()
    @State private var showAlert: Bool = false

    let colors: [Color] = [.yellow, .purple, .green, .blue, .orange, .pink]

    var body: some View {
        VStack {
            Text("Yeni Not")
                .font(.title)
                .padding()

            TextField("Notunuzu yazın...", text: $newNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

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
                .onChange(of: isReminderOn) { newValue in
                    if newValue && !notificationManager.isNotificationAllowed {
                        isReminderOn = false // 🚨 Toggle'ı otomatik geri kapat
                        showAlert = true // 🚨 Alert'i aç
                    }
                }

            // ⏰ **Tarih ve Saat Seçici**
            if isReminderOn {
                DatePicker("Hatırlatma Zamanı", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                    .padding()
            }

            Button {
                if !newNote.isEmpty {
                    let id = UUID().uuidString
                    viewModel.addNote(text: newNote, color: selectedColor, id: id, date: isReminderOn ? reminderDate : nil)

                    if isReminderOn {
                        NotificationManager.shared.scheduleNotification(id: id, note: newNote, date: reminderDate)
                    }
                }
                dismiss()
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
        .onAppear {
            notificationManager.checkNotificationStatus() // 📌 İlk açılışta güncelle
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            print("Uygulama aktif oldu, bildirim izni tekrar kontrol ediliyor...")
            notificationManager.checkNotificationStatus() // 📌 Uygulamaya geri dönüldüğünde çalışacak!
        }
        .alert("Bildirimlere İzin Verilmedi", isPresented: $showAlert) {
            Button("Ayarları Aç") {
                notificationManager.openAppSettings()
            }
            Button("Tamam", role: .cancel) { }
        } message: {
            Text("Hatırlatma eklemek için bildirimlere izin vermelisiniz. Ayarlardan bildirim iznini açabilirsiniz.")
        }
    }
}
