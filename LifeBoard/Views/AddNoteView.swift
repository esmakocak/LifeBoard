import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: NoteViewModel

    @State private var newNote = ""  // Yeni not metni
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
                    viewModel.addNote(text: newNote, color: selectedColor) // 📌 CoreData'ya not ekle
                }
                dismiss()  // 📌 Sheet’i kapat
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}
