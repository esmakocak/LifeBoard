//
//  ContentView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 5.02.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            
            MedicineView(context: PersistenceController.shared.context)
                .tabItem {
                    Label("Medicines", systemImage: "pills.fill")
                }
                .tag(1)
            
            NoteView(context: PersistenceController.shared.context)
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(0)
            
            
            GameView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller.fill")
                }
                .tag(2)
        }
        .accentColor(Color("darkPurple"))
    }
}

#Preview {
    ContentView()
}
