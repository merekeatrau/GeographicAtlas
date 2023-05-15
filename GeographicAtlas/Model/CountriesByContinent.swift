//
//  CountriesByContinent.swift
//  GeographicAtlas
//
//  Created by Mereke on 15.05.2023.
//

import Foundation

class CountriesByContinent {
    private var continents: [String] = []
    private var countries: [String: [Country]] = [:]
    
    var numberOfContinents: Int {
        return continents.count
    }
    
    func numberOfCountriesInContinent(at index: Int) -> Int {
        guard index < continents.count else { return 0 }
        let continent = continents[index]
        return countries[continent]?.count ?? 0
    }
    
    func continentName(at index: Int) -> String {
        guard index < continents.count else { return "" }
        return continents[index]
    }
    
    func country(at indexPath: IndexPath) -> Country? {
        guard indexPath.section < continents.count,
              indexPath.row < (countries[continents[indexPath.section]]?.count ?? 0)
        else { return nil }
        let continent = continents[indexPath.section]
        return countries[continent]?[indexPath.row]
    }
    
    func updateWith(countries: [Country]) {
        for country in countries {
            if let continent = country.continents?.first {
                if self.countries[continent] != nil {
                    self.countries[continent]?.append(country)
                } else {
                    self.countries[continent] = [country]
                    continents.append(continent)
                }
            }
        }
    }
}

