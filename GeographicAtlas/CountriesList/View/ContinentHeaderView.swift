//
//  ContinentHeaderView.swift
//  GeographicAtlas
//
//  Created by Mereke on 13.05.2023.
//

import UIKit
import SnapKit
import SkeletonView

class ContinentHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "ContinentHeaderView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.isSkeletonable = true
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isSkeletonable = true
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(container)
        container.addSubview(label)
        container.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(0)
        }
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        let uppercasedTitle = title.uppercased()
        let attributedString = NSAttributedString(string: uppercasedTitle, attributes: [NSAttributedString.Key.kern: 1.2])
        label.attributedText = attributedString
    }
}
