//
//  ContentTableCell.swift
//  GeographicAtlas
//
//  Created by Mereke on 14.05.2023.
//

import UIKit

class ContentTableCell: UITableViewCell {
    
    static let identifier = "ContentTableCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bullet"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(mainStackView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(captionLabel)
        
        mainStackView.addArrangedSubview(iconImageView)
        mainStackView.addArrangedSubview(textStackView)
    }
    
    private func setConstraints() {
        mainStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
        }
    }
    
    func configure(key: String, value: String) {
        titleLabel.text = key
        captionLabel.text = value
    }
}
