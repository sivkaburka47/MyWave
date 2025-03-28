//
//  WeekCell.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 28.02.2025.
//

import UIKit

final class WeekCell: UICollectionViewCell {
    static let identifier = "WeekCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "VelaSans-Regular", size: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dateLabel)
        contentView.addSubview(selectionIndicator)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        selectionIndicator.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, isSelected: Bool) {
        dateLabel.text = text
        selectionIndicator.isHidden = !isSelected
        dateLabel.textColor = isSelected ? .white : .gray
    }
}
