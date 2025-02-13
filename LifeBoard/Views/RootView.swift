//
//  RootView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 13.02.2025.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenWelcomeScreen") private var hasSeenWelcomeScreen = false

    var body: some View {
        if hasSeenWelcomeScreen {
            ContentView() 
        } else {
            WelcomeView()
        }
    }
}

#Preview {
    RootView()
}
