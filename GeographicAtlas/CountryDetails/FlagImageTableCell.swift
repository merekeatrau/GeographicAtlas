//
//  FlagImageTableCell.swift
//  GeographicAtlas
//
//  Created by Mereke on 14.05.2023.
//

import UIKit
import Kingfisher

class FlagImageTableCell: UITableViewCell {

    static let identifier = "FlagImageTableCell"
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        return imageView
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
        contentView.addSubview(flagImageView)
    }
    
    private func setConstraints() {
        flagImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(details: CountryDetails?) {
        if let pngFlagUrlString = details?.flags?.png,
           let pngFlagUrl = URL(string: pngFlagUrlString) {
            let cacheKey = "\(pngFlagUrl)"
            flagImageView.kf.setImage(with: pngFlagUrl, placeholder: nil, options: [.transition(.fade(0.2))]) { result in
                switch result {
                case .success(_):
                   break
                case .failure(let error):
                    print("Image loading error: \(error)")
                }
            }
        } else if let svgFlagUrlString = details?.flags?.svg,
                  let svgFlagUrl = URL(string: svgFlagUrlString) {
            let cacheKey = "\(svgFlagUrl)"
            flagImageView.kf.setImage(with: svgFlagUrl, placeholder: nil, options: [.transition(.fade(0.2))]) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    print("Image loading error: \(error)")
                }
            }
        }
    }

}
