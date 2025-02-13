//
//  ColorExtension.swift
//  LifeBoard
//
//  Created by Esma Koçak on 10.02.2025.
//

import Foundation
import SwiftUI

extension Color {
    /// SwiftUI `Color` nesnesini Hex koduna çevirir.
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else { return "#FFFFFF" }
        let r = Int((components[0] * 255).rounded())
        let g = Int((components[1] * 255).rounded())
        let b = Int((components[2] * 255).rounded())
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    /// Hex kodunu SwiftUI `Color` nesnesine çevirir.
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
}
