//
//  CountryTableCell.swift
//  GeographicAtlas
//
//  Created by Mereke on 13.05.2023.
//

import UIKit
import SnapKit
import Kingfisher

class CountryTableCell: UITableViewCell {
    
    static let identifier = "CountryTableCell"
    
    var isExpanded: Bool = false
    
    private let mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpanded = false
    }
    
    private let mainStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 12
        stackview.backgroundColor = .systemGray6
        return stackview
    }()
    
    private let textStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.spacing = 4
        return stackview
    }()
    
    private let headStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 12
        return stackview
    }()
    
    private let additionalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.spacing = 8
        return stackview
    }()
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Flag"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 82, height: 48))
        }
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Kazakhstan"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let capitalLabel: UILabel = {
        let label = UILabel()
        label.text = "Astana"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "arrow_up"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let learnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn More", for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        return button
    }()
    
    lazy private var labels: [UILabel] = [
        createLabel(text: "Population: 19 mln"),
        createLabel(text: "Area: 2.725 mln km²"),
        createLabel(text: "Currencies: Tenge (₸) (KZT)")]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mainContainer)
        mainContainer.addSubview(mainStackView)
        textStackView.addArrangedSubview(countryLabel)
        textStackView.addArrangedSubview(capitalLabel)
        headStackView.addArrangedSubview(flagImageView)
        headStackView.addArrangedSubview(textStackView)
        headStackView.addArrangedSubview(expandButton)
        for label in labels {
            additionalStackView.addArrangedSubview(label)
        }
        mainStackView.addArrangedSubview(headStackView)
        mainStackView.addArrangedSubview(additionalStackView)
        mainStackView.addArrangedSubview(learnMoreButton)
    }
    
    private func setupConstraints() {
        mainContainer.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(6)
        }
        
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        return label
    }
    
    func configure(country: Country?) {
        guard let country = country,
            let population = country.population,
            let area = country.area,
            let name = country.name?.common,
            let capitalArray = country.capital,
            let currencies = country.currencies else {
                return
        }

        let capitalString = capitalArray.joined(separator: ", ")

        countryLabel.text = name
        capitalLabel.text = capitalString

        labels[0].text = "Population: \(formatNumber(population)) mln"
        labels[1].text = "Area: \(formatNumber(Int(area))) mln km²"

        let currencyList = currencies.compactMap { (key, currency) -> String? in
            if let currencyName = currency.name, let currencySymbol = currency.symbol {
                return "\(currencyName) (\(currencySymbol))"
            }
            return nil
        }

        labels[2].text = "Currencies: " + currencyList.joined(separator: ", ")

        if let pngFlagUrlString = country.flags?.png,
        let pngFlagUrl = URL(string: pngFlagUrlString) {
            flagImageView.kf.setImage(with: pngFlagUrl)
        } else if let svgFlagUrlString = country.flags?.svg,
                let svgFlagUrl = URL(string: svgFlagUrlString) {
            flagImageView.kf.setImage(with: svgFlagUrl)
        }
    }

    func formatNumber(_ number: Int) -> String {
        return String(format: "%.1f", Float(number) / 1000000)
    }

}


