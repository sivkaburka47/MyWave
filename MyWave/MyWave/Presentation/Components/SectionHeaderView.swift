//
//  SectionHeaderView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 27.02.2025.
//

import UIKit
import SnapKit


final class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.font = UIFont(name: "VelaSans-Medium", size: 16)
        titleLabel.textColor = .white
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
