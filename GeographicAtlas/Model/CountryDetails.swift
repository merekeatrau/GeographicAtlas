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
    let region: String?
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
        case region
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
        region = try container.decodeIfPresent(String.self, forKey: .region)
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

