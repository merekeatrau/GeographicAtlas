//
//  .swift
//  GeographicAtlas
//
//  Created by Mereke on 14.05.2023.
//

import Foundation
import Alamofire

class CountryDetailsNetworkService {
    static let shared = CountryDetailsNetworkService()
    
    private let baseUrl = "https://restcountries.com/v3.1/alpha/"
    
    private init() {}
    
    func getCountryDetails(with id: String, completion: @escaping ([CountryDetails]) -> Void) {
        let url = "\(baseUrl)/\(id)"
        
        AF.request(url).responseDecodable(of: [CountryDetails].self) { response in
            switch response.result {
            case .success(let details):
                completion(details)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
