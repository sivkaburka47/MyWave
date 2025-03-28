//
//  AddTagCell.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 25.02.2025.
//

import UIKit

class AddTagCell: UICollectionViewCell {
    static let identifier = "AddTagCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
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
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        configure()
    }
    
    func configure() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        imageView.image = image
    }
}
