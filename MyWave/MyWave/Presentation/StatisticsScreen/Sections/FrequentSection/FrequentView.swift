//
//  FrequentView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 01.03.2025.
//

import UIKit
import SnapKit

final class FrequentView: UIView {
    private let titleScreen = UILabel()
    private let weekLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .black
        
        titleScreen.text = "Самые частые эмоции"
        titleScreen.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        titleScreen.textColor = .white
        titleScreen.numberOfLines = 0
        addSubview(titleScreen)
        
        titleScreen.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        weekLabel.text = "неделя"
        weekLabel.font = UIFont(name: "VelaSans-Regular", size: 20)
        weekLabel.textColor = .white
        weekLabel.numberOfLines = 0
        addSubview(weekLabel)
        
        weekLabel.snp.makeConstraints { make in
            make.top.equalTo(titleScreen.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    func updateWeekLabel(with week: String) {
        weekLabel.text = "неделя: \(week)"
    }

}

