//
//  VerticalPageControl.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 28.02.2025.
//

import UIKit

final class VerticalPageControl: UIStackView {
    var numberOfPages: Int = 0 {
        didSet { setupDots() }
    }
    
    var currentPage: Int = 0 {
        didSet { updateDots() }
    }
    
    private var dots: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        alignment = .center
        spacing = 4
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDots() {
        dots.forEach { $0.removeFromSuperview() }
        dots.removeAll()
        
        (0..<numberOfPages).forEach { _ in
            let dot = UIView()
            dot.backgroundColor = UIColor(named: "grayGrad")
            dot.layer.cornerRadius = 2
            dot.snp.makeConstraints { $0.size.equalTo(4) }
            addArrangedSubview(dot)
            dots.append(dot)
        }
        
        updateDots()
    }
    
    private func updateDots() {
        dots.enumerated().forEach { index, dot in
            dot.backgroundColor = index == currentPage ? .white : UIColor(named: "grayGrad")
        }
    }
}
