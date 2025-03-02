//
//  GeneralView.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 01.03.2025.
//

import UIKit
import SnapKit

final class GeneralView: UIView {
    private let titleScreen = UILabel()
    private let numberEntries = UILabel()
    private let circlesContainer = UIView()
    private let emotionCirclesView = EmotionCirclesView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        titleScreen.text = "Эмоции по категориям"
        titleScreen.font = UIFont(name: "Gwen-Trial-Regular", size: 36)
        titleScreen.textColor = .white
        titleScreen.numberOfLines = 0
        addSubview(titleScreen)
        
        titleScreen.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        numberEntries.text = "записей"
        numberEntries.font = UIFont(name: "VelaSans-Regular", size: 20)
        numberEntries.textColor = .white
        addSubview(numberEntries)
        
        numberEntries.snp.makeConstraints { make in
            make.top.equalTo(titleScreen.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        addSubview(circlesContainer)
        circlesContainer.snp.makeConstraints { make in
            make.top.equalTo(numberEntries.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
        
        circlesContainer.addSubview(emotionCirclesView)
        emotionCirclesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func update(with notes: [Note]) {
        numberEntries.text = "\(notes.count) записей"
        let percentages = calculatePercentages(notes: notes)
        emotionCirclesView.percentages = percentages
        emotionCirclesView.setNeedsLayout()
    }
    
    private func calculatePercentages(notes: [Note]) -> [(Float, EmotionType)] {
        let countDict = notes.reduce(into: [:]) { counts, note in
            counts[note.type, default: 0] += 1
        }
        
        let total = Float(notes.count)
        return countDict.map { (Float($0.value) / total * 100, $0.key) }
    }
}



