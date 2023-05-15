//
//  FormatFunctions.swift
//  GeographicAtlas
//
//  Created by Mereke on 15.05.2023.
//

import Foundation

func formatNumber(_ number: Int) -> String {
    return String(format: "%.1f", Float(number) / 1000000)
}

func formatArea(_ number: Double?) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    formatter.maximumFractionDigits = 0
    guard let number = number else {
        return "0"
    }
    return formatter.string(from: NSNumber(value: number)) ?? "0"
}
