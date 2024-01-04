//
//  NavigationBarView.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/4/24.
//

import UIKit

import SnapKit

final class NavigationBarView: UIView {
    
    // MARK: - Size
    
    let absoluteWidth = UIScreen.main.bounds.width
    
    // MARK: - UI Properties

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body1_bold)
        label.textColor = .gray700
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.NavigationBar.buttonBack, for: .normal)
        return button
    }()
    
    let navigationBottomLineView: UIView = {
        let line = UIView()
        line.backgroundColor = .gray200
        return line
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyles()
        setHierachy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension NavigationBarView {
    func setStyles() {
        self.backgroundColor = .white
    }
    
    func setHierachy() {
        addSubviews(titleLabel, backButton, navigationBottomLineView)
    }
    
    func setLayout() {
//        self.snp.makeConstraints {
//            $0.width.equalTo(375)
//            $0.height.equalTo(60)
//        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(absoluteWidth / 375 * 48)
        }
        
        navigationBottomLineView.snp.makeConstraints {
            $0.width.equalTo(absoluteWidth / 375 * 375)
            $0.top.equalTo(backButton.snp.bottom).offset(4)
        }
    }
}
