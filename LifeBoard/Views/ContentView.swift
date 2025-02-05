//
//  ContentView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            MedicineView()
                .tabItem {
                    Label("Medicines", systemImage: "pills.fill")
                }
            
            NoteView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
            
            GameView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller.fill")
                }
            
        } .accentColor(.red)
    }
}

#Preview {
    ContentView()
}
