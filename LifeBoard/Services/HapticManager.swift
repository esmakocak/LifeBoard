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
    
    // Notification vibrations (success, error, warning)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    // Touch and impact vibrations (light, medium, heavy, rigid, soft)
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    // Feedback vibration (e.g., when a selection is made)
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}



