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

func formatCoordinates(lat: Double, lng: Double) -> String {
    let latDegrees = Int(lat)
    let latMinutes = Int((lat - Double(latDegrees)) * 60)
    
    let lngDegrees = Int(lng)
    let lngMinutes = Int((lng - Double(lngDegrees)) * 60)
    
    return "\(latDegrees)°\(latMinutes)', \(lngDegrees)°\(lngMinutes)'"
}
