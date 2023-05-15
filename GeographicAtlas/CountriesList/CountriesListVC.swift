//
//  ViewController.swift
//  GeographicAtlas
//
//  Created by Mereke on 13.05.2023.
//

import UIKit
import SnapKit

class CountriesListViewController: UIViewController {
    
    private let networkManager = CountriesNetworkService.shared
    private var countries: [String: [Country]] = [:]
    private var continents: [String] = []
    
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
        title = "World Countries"
        setTableview()
        fetchCountries()
        self.navigationItem.backButtonTitle = ""
    }
    
    private func setTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableCell.self, forCellReuseIdentifier: CountryTableCell.identifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return continents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let continent = continents[section]
        return countries[continent]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableCell.identifier, for: indexPath) as? CountryTableCell else {
            return UITableViewCell()
        }
        cell.layer.cornerRadius = 8
        let continent = continents[indexPath.section]
        if let country = countries[continent]?[indexPath.row] {
            cell.configure(country: country)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let continent = continents[indexPath.section]
        if let country = countries[continent]?[indexPath.row] {
            let CountryDetailsVC = CountryDetailsViewController(countryCode: country.countryCode ?? "KZ")
            CountryDetailsVC.title = country.name?.common
            navigationController?.pushViewController(CountryDetailsVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContinentHeaderView") as? ContinentHeaderView ?? ContinentHeaderView(reuseIdentifier: "ContinentHeaderView")
        let continent = continents[section]
        headerView.configure(with: continent)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension CountriesListViewController {
    private func fetchCountries() {
        networkManager.getAllCountries { [weak self] countriesData in
            for country in countriesData {
                if let continent = country.continents?.first {
                    if self?.countries[continent] != nil {
                        self?.countries[continent]?.append(country)
                    } else {
                        self?.countries[continent] = [country]
                        self?.continents.append(continent)
                    }
                }
            }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

