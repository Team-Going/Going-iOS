//
//  NavigationView.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class NavigationView: UIView {

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
        setHierarchy()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Extension

private extension NavigationView {
    func setStyles() {
        self.backgroundColor = .white
    }

    func setHierarchy() {
        addSubviews(titleLabel, backButton, navigationBottomLineView)
    }

    func setLayout() {

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }

        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.size.equalTo(ScreenUtils.getWidth(48))
        }

        navigationBottomLineView.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(375))
            $0.top.equalTo(backButton.snp.bottom).offset(4)
            $0.height.equalTo(1)
        }
    }
}
