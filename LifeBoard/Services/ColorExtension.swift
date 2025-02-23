//
//  ColorExtension.swift
//  LifeBoard
//
//  Created by Esma Koçak on 10.02.2025.
//

import Foundation
import SwiftUI

extension Color {
    
    // Converts a SwiftUI `Color` object to a Hex code.
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else { return "#FFFFFF" }
        let r = Int((components[0] * 255).rounded())
        let g = Int((components[1] * 255).rounded())
        let b = Int((components[2] * 255).rounded())
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    // Converts a Hex code to a SwiftUI `Color` object.
    static func fromHex(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
    
    //Function that returns a darker version of a light color.
    static func getDarkColor(for hex: String) -> Color {
        let lightToDarkMapping: [String: String] = [
            "#FFC8DD": "darkPink",   // lightPink → darkPink
            "#E2C4F2": "darkPurple", // lightPurple → darkPurple
            "#BDE0FE": "darkBlue"    // lightBlue → darkBlue
        ]
        
        let sanitizedHex = hex.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let darkColorName = lightToDarkMapping[sanitizedHex] {
            return Color(darkColorName)
        } else {
            return Color.black // default color
        }
    }
}
