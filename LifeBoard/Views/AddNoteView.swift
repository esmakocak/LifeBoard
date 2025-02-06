import SwiftUI
import AVFoundation

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var notes: [(text: String, color: Color)] // Notlar artık renk ile saklanıyor
    
    @State private var newNote = ""  // Yeni not girişi
    @State private var selectedColor: Color = .yellow // Varsayılan renk

    let colors: [Color] = [.yellow, .purple, .green, .blue, .orange, .pink] // Seçilebilir renkler

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

            Button("Kaydet") {
                if !newNote.isEmpty {
                    notes.append((text: newNote, color: selectedColor))  // Not ve rengi kaydet
                }
                dismiss()  // Sheet’i kapat
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
