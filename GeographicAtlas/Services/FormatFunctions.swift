//
//  FormatFunctions.swift
//  GeographicAtlas
//
//  Created by Mereke on 15.05.2023.
//

import Foundation
import UIKit

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

func createAttributedText(title: String, detail: String) -> NSAttributedString {
    let titleAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.systemGray,
        .font: UIFont.systemFont(ofSize: 15, weight: .regular)
    ]
    
    let detailAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.black,
        .font: UIFont.systemFont(ofSize: 15, weight: .regular)
    ]
    
    let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
    let attributedDetail = NSAttributedString(string: detail, attributes: detailAttributes)
    
    let attributedText = NSMutableAttributedString()
    attributedText.append(attributedTitle)
    attributedText.append(attributedDetail)
    
    return attributedText
}
