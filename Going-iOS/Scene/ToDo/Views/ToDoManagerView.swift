//
//  ToDoManagerCollectionView.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/24/24.
//

import UIKit

class ToDoManagerCollectionView: UIView {

    private let managerLabel: UILabel = DOOLabel(
        font: .pretendard(.body2_bold),
        color: .gray700, 
        text: StringLiterals.ToDo.allocation
    )
    
    let todoManagerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()

}
