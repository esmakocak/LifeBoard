//
//  MathQuizView.swift
//  LifeBoard
//
//  Created by Esma Koçak on 6.02.2025.
//

import SwiftUI

struct MathQuizView: View {
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .padding()
                }
                
                Spacer()
            }
            
            Text("Math Quiz")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            Spacer()
        }
    }
}

#Preview {
    MathQuizView()
}
