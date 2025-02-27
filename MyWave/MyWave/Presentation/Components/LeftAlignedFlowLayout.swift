//
//  LeftAlignedFlowLayout.swift
//  MyWave
//
//  Created by Станислав Дейнекин on 26.02.2025.
//

import UIKit

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin: CGFloat = sectionInset.left
        var lastYPosition: CGFloat = -1
        
        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y != lastYPosition {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            lastYPosition = layoutAttribute.frame.origin.y
        }
        
        return attributes
    }
}


