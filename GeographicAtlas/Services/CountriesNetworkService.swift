//
//  APIManager.swift
//  GeographicAtlas
//
//  Created by Mereke on 14.05.2023.
//

import Foundation
import Alamofire

class CountriesNetworkService {
    static let shared = CountriesNetworkService()
    
    private let baseUrl = "https://restcountries.com/v3.1"
    
    private init() {}
    
    func getAllCountries(completion: @escaping ([Country]) -> Void) {
        let url = "\(baseUrl)/all"
        
        AF.request(url).responseDecodable(of: [Country].self) { response in
            switch response.result {
            case .success(let countries):
                completion(countries)
            case .failure(let error):
                print("Error: \(error)")
                completion([])
            }
        }
    }
}
