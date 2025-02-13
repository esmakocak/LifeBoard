//
//  HapticManager.swift
//  LifeBoard
//
//  Created by Esma Koçak on 10.02.2025.
//

import Foundation
import SwiftUI

class HapticManager {
    static let instance = HapticManager() // Singleton
    
    /// Bildirim titreşimleri (başarı, hata, uyarı)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// Dokunma ve darbe titreşimleri (light, medium, heavy, rigid, soft)
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// Geri bildirim titreşimi (örneğin: bir seçim yapıldığında)
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
