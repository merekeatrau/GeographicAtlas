//
//  ViewController.swift
//  GeographicAtlas
//
//  Created by Mereke on 13.05.2023.
//

import UIKit
import SnapKit
import SkeletonView

class CountriesListViewController: UIViewController {
    
    private let networkManager = CountriesNetworkService.shared
    private var countriesByContinent = CountriesByContinent()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableCell.self, forCellReuseIdentifier: CountryTableCell.identifier)
        tableView.register(ContinentHeaderView.self, forHeaderFooterViewReuseIdentifier: ContinentHeaderView.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchCountries()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "World Countries"
        self.navigationItem.backButtonTitle = ""
        
        tableView.isSkeletonable = true
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension CountriesListViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource, SkeletonTableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return countriesByContinent.numberOfContinents
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesByContinent.numberOfCountriesInContinent(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableCell.identifier, for: indexPath) as? CountryTableCell,
              let country = countriesByContinent.country(at: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(country: country)
        cell.onLearnMoreTapped = { [weak self] in
            let countryDetailsVC = CountryDetailsViewController(countryCode: country.countryCode ?? "KZ")
            countryDetailsVC.title = country.name?.common
            self?.navigationController?.pushViewController(countryDetailsVC, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CountryTableCell else { return }
        cell.isExpanded.toggle()
        UIView.transition(with: cell, duration: 0.3, options: .transitionCrossDissolve, animations: {
            cell.updateView()
        })
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ContinentHeaderView") as? ContinentHeaderView ?? ContinentHeaderView(reuseIdentifier: "ContinentHeaderView")
        let continent = countriesByContinent.continentName(at: section)
        headerView.configure(with: continent)
        return headerView
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CountryTableCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        return ContinentHeaderView.identifier
    }
}

extension CountriesListViewController {
    private func fetchCountries() {
        tableView.showAnimatedGradientSkeleton()
        
        networkManager.getAllCountries { [weak self] countries in
            self?.countriesByContinent.updateWith(countries: countries)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.hideSkeleton()
            }
        }
    }
}
