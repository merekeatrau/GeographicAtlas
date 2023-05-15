//
//  Country.swift
//  GeographicAtlas
//
//  Created by Mereke on 13.05.2023.
//

import Foundation
import UIKit

struct Country: Decodable {
    var name: CountryName?
    var countryCode: String?
    var capital: [String]?
    var population: Int?
    var flags: Flags?
    var area: Double?
    var currencies: [String: Currency]?
    var continents: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case cca2
        case capital
        case population
        case flags
        case area
        case currencies
        case continents
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(CountryName.self, forKey: .name)
        countryCode = try container.decodeIfPresent(String.self, forKey: .cca2)
        capital = try container.decodeIfPresent([String].self, forKey: .capital)
        population = try container.decodeIfPresent(Int.self, forKey: .population)
        flags = try container.decodeIfPresent(Flags.self, forKey: .flags)
        area = try container.decodeIfPresent(Double.self, forKey: .area)
        currencies = try container.decodeIfPresent([String: Currency].self, forKey: .currencies)
        continents = try container.decodeIfPresent([String].self, forKey: .continents)
    }
}

struct Flags: Decodable {
    var png: String?
    var svg: String?
    var alt: String?
}


struct CountryName: Decodable {
    var common: String?
}

struct Currency: Decodable {
    var name: String?
    var symbol: String?
}
