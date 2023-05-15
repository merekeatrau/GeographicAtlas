//
//  CountryDetails.swift
//  GeographicAtlas
//
//  Created by Mereke on 14.05.2023.
//

import Foundation
import UIKit

struct CountryDetails: Decodable {
    let name: CountryName?
    let countryCode: String?
    let capital: [String]?
    let capitalInfo: CapitalInfo?
    let subregion: String?
    let population: Int?
    let area: Double?
    let currencies: [String: Currency]?
    let timezones: [String]?
    let flags: Flags?
    
    enum CodingKeys: String, CodingKey {
        case name
        case cca2
        case capital
        case capitalInfo = "capitalInfo"
        case subregion
        case population
        case area
        case currencies
        case timezones = "timezones"
        case flags
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(CountryName.self, forKey: .name)
        countryCode = try container.decodeIfPresent(String.self, forKey: .cca2)
        capital = try container.decodeIfPresent([String].self, forKey: .capital)
        capitalInfo = try container.decodeIfPresent(CapitalInfo.self, forKey: .capitalInfo)
        subregion = try container.decodeIfPresent(String.self, forKey: .subregion)
        population = try container.decodeIfPresent(Int.self, forKey: .population)
        area = try container.decodeIfPresent(Double.self, forKey: .area)
        currencies = try container.decodeIfPresent([String: Currency].self, forKey: .currencies)
        timezones = try container.decodeIfPresent([String].self, forKey: .timezones)
        flags = try container.decodeIfPresent(Flags.self, forKey: .flags)
    }
}

struct CapitalInfo: Decodable {
    let latlng: [Double]?
}

struct NativeName: Decodable {
    let official: String?
    let common: String?
}

extension CountryDetails {
    var detailsKeys: [String] {
        return [
            "Region",
            "Capital",
            "Capital coordinates",
            "Population",
            "Area",
            "Currency",
            "Timezones"
        ]
    }
    
    var detailsDict: [String: String] {
        return [
            "Region": subregion ?? "",
            "Capital": capital?.first ?? "",
            "Capital coordinates": (capitalInfo?.latlng).map { formatCoordinates(lat: $0[0], lng: $0[1]) } ?? "",
            "Population": population.map { "\(formatNumber($0)) mln" } ?? "",
            "Area": area.map { "\(formatArea($0)) km²" } ?? "",
            "Currency": currencies?.map { "\($0.key): \(String(describing: $0.value.name!)) (\($0.value.symbol ?? ""))" }.joined(separator: "\n") ?? "",
            "Timezones": timezones?.joined(separator: "\n") ?? ""
        ]
    }
}

