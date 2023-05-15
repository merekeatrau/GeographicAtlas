//
//  CountryDetailsVC.swift
//  GeographicAtlas
//
//  Created by Mereke on 14.05.2023.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    private let networkManager = CountryDetailsNetworkService.shared
    
    var countryCode: String
    
    private var details: CountryDetails?
    private var detailsDict: [String: String] = [:]
    private var detailsKeys: [String] = []
    
    init(countryCode: String) {
        self.countryCode = countryCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 216
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTableview()
        fetchDetails()
    }
    
    private func setTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FlagImageTableCell.self, forCellReuseIdentifier: FlagImageTableCell.identifier)
        tableView.register(ContentTableCell.self, forCellReuseIdentifier: ContentTableCell.identifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CountryDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsKeys.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FlagImageTableCell.identifier, for: indexPath) as? FlagImageTableCell else {
                return UITableViewCell()
            }
            cell.configure(details: details)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableCell.identifier, for: indexPath) as? ContentTableCell else {
                return UITableViewCell()
            }
            let key = detailsKeys[indexPath.row - 1]
            let value = detailsDict[key] ?? ""
            cell.configure(key: key, value: value)
            return cell
            
        }
    }
}

extension CountryDetailsViewController {
    private func fetchDetails() {
        networkManager.getCountryDetails(with: countryCode) { [weak self] countryDetails in
            self?.details = countryDetails.first
            if let details = self?.details {
                self?.detailsKeys = [
                    "Region",
                    "Capital",
                    "Capital coordinates",
                    "Population",
                    "Area",
                    "Currency",
                    "Timezones"
                ]
                self?.detailsDict = [
                    "Region": details.region ?? "",
                    "Capital": details.capital?.first ?? "",
                    "Capital coordinates": {
                        if let self = self, let latlng = details.capitalInfo?.latlng {
                            return self.formatCoordinates(lat: latlng[0], lng: latlng[1])
                        } else {
                            return ""
                        }
                    }(),
                    "Population": {
                        if let population = details.population {
                            return "\(formatNumber(population)) mln"
                        } else {
                            return ""
                        }
                    }(),
                    "Area": {
                        if let area = details.area {
                            return "\(formatArea(area)) km²"
                        } else {
                            return ""
                        }
                    }(),
                    "Currency": details.currencies?.map { "\($0.key): \(String(describing: $0.value.name!)) (\($0.value.symbol ?? ""))" }.joined(separator: "\n") ?? "",
                    "Timezones": details.timezones?.joined(separator: "\n") ?? ""
                ]
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func formatCoordinates(lat: Double, lng: Double) -> String {
        let latDegrees = Int(lat)
        let latMinutes = Int((lat - Double(latDegrees)) * 60)
        
        let lngDegrees = Int(lng)
        let lngMinutes = Int((lng - Double(lngDegrees)) * 60)
        
        return "\(latDegrees)°\(latMinutes)', \(lngDegrees)°\(lngMinutes)'"
    }
    
}
