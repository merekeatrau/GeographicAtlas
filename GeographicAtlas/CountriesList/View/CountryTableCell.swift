//
//  CountryTableCell.swift
//  GeographicAtlas
//
//  Created by Mereke on 13.05.2023.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

class CountryTableCell: UITableViewCell {
    
    static let identifier = "CountryTableCell"
    
    var onLearnMoreTapped: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isExpanded = false
        updateView()
        
        flagImageView.kf.cancelDownloadTask()
        flagImageView.image = nil
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    var isExpanded: Bool = false
    
    private let mainContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var mainStackView = createStackView(axis: .vertical, spacing: 12, alignment: .fill)
    private lazy var textStackView = createStackView(axis: .vertical, spacing: 4, alignment: .leading)
    private lazy var headStackView = createStackView(axis: .horizontal, spacing: 12, alignment: .center)
    private lazy var additionalStackView = createStackView(axis: .vertical, spacing: 8, alignment: .leading)
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
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
        label.numberOfLines = 1
        label.text = "KazakhstanKazakhstanKazakhstan"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let capitalLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "KazakhstanKazakhstan"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "arrow_up"), for: .normal)
        button.tintColor = .systemGray6
        return button
    }()
    
    let learnMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn More", for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        button.addTarget(self, action: #selector(learnMoreTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var labels: [UILabel] = [
        createLabel(text: ""),
        createLabel(text: ""),
        createLabel(text: "")]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        selectionStyle = .none
        expandButton.isHidden = true
        setupViews()
        setupConstraints()
        setupSkeletonable()
        expandButton.isHidden = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSkeletonable() {
        isSkeletonable = true
        [mainContainer, mainStackView, headStackView, textStackView, flagImageView, expandButton, capitalLabel, countryLabel].forEach {
            $0.isSkeletonable = true
        }

        additionalStackView.isSkeletonable = false
        learnMoreButton.isSkeletonable = false
    }
    
    private func setupViews() {
        contentView.addSubview(mainContainer)
        mainContainer.addSubview(mainStackView)
        [countryLabel, capitalLabel].forEach { textStackView.addArrangedSubview($0) }
        [flagImageView, textStackView, expandButton].forEach { headStackView.addArrangedSubview($0) }
        labels.forEach { additionalStackView.addArrangedSubview($0) }
        [headStackView, additionalStackView, learnMoreButton].forEach { mainStackView.addArrangedSubview($0) }
        additionalStackView.isHidden = true
        learnMoreButton.isHidden = true
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
    
    @objc private func learnMoreTapped() {
        onLearnMoreTapped?()
    }
}

extension CountryTableCell {
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        return label
    }
    
    private func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .fill) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        return stackView
    }
    
    func configure(country: Country?) {
        guard let country = country else { return }
        
        let name = country.name?.common ?? "N/A"
        let capitalString = country.capital?.joined(separator: ", ") ?? "N/A"
        let population = country.population != nil ? formatNumber(country.population!) + " mln" : "N/A"
        let area = country.area != nil ? formatNumber(Int(country.area!)) + " mln km²" : "N/A"
        
        let currencyList = country.currencies?.compactMap { (key, currency) -> String? in
            if let currencyName = currency.name, let currencySymbol = currency.symbol {
                return "\(currencyName) (\(currencySymbol))"
            }
            return nil
        }.joined(separator: ", ") ?? "N/A"
        
        countryLabel.text = name
        capitalLabel.text = capitalString
        labels[0].attributedText = createAttributedText(title: "Population: ", detail: population)
        labels[1].attributedText = createAttributedText(title: "Area: ", detail: area)
        labels[2].attributedText = createAttributedText(title: "Currencies: ", detail: currencyList)

        if let pngFlagUrlString = country.flags?.png,
           let pngFlagUrl = URL(string: pngFlagUrlString) {
            let cacheKey = "\(pngFlagUrl)"
            let options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
            
            if let image = ImageCache.default.retrieveImageInMemoryCache(forKey: cacheKey) {
                flagImageView.image = image
            } else {
                flagImageView.kf.setImage(with: pngFlagUrl, placeholder: nil, options: options) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let value):
                        ImageCache.default.store(value.image, forKey: cacheKey)
                        self.flagImageView.image = value.image
                    case .failure(let error):
                        print("Image downloading error: \(error)")
                    }
                }
            }
        }
        expandButton.tintColor = .black
    }
    
    func updateView() {
        additionalStackView.isHidden = !isExpanded
        learnMoreButton.isHidden = !isExpanded
        expandButton.setImage(UIImage(named: isExpanded ? "arrow_down" : "arrow_up"), for: .normal)
    }
}
