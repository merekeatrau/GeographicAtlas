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
    
    private var details: CountryDetails? {
        didSet {
            detailsDict = details?.detailsDict ?? [:]
            detailsKeys = details?.detailsKeys ?? []
        }
    }
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
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FlagImageTableCell.identifier, for: indexPath) as? FlagImageTableCell else {
                return UITableViewCell()
            }
            cell.configure(details: details)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableCell.identifier, for: indexPath) as? ContentTableCell else {
                return UITableViewCell()
            }
            let key = details?.detailsKeys[indexPath.row - 1] ?? ""
            let value = details?.detailsDict[key] ?? ""
            cell.configure(key: key, value: value)
            return cell
        }
    }
}

extension CountryDetailsViewController {
    private func fetchDetails() {
        networkManager.getCountryDetails(with: countryCode) { [weak self] countryDetails in
            self?.details = countryDetails.first
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

