//
//  TagCell.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 25.02.2025.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = UIColor(named: "statItemBG")
        contentView.layer.cornerRadius = 18
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
    
    func configure(with text: String, isSelected: Bool) {
        tagLabel.text = text
        contentView.backgroundColor = isSelected ? UIColor(named: "grayGrad") : UIColor(named: "statItemBG")
    }
}
